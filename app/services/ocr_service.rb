require "net/http"
require "base64"

# Extracts raw text from an ID document image (Aadhaar/PAN card photo) via the
# free OCR.space OCR API (https://ocr.space/ocrapi). Kept behind this single
# class so a different OCR provider (Google Vision, AWS Textract, self-hosted
# Tesseract, ...) can be swapped in later without touching callers - see
# .extract_text.
#
# Free tier limits we work around here:
#   * 1 MB upload size  -> the image is auto-oriented and re-compressed to JPEG
#                          under that cap before sending (see #image_data_uri).
#   * 500 requests/day per IP / 25,000 per month - enough for KYC onboarding.
class OcrService
  class ExtractionError < StandardError; end
  class ConfigurationError < StandardError; end

  OCR_SPACE_ENDPOINT = "https://api.ocr.space/parse/image"
  # Free OCR.space key (25,000 requests/month, 500/day per IP). Registered at
  # https://ocr.space/ocrapi/freekey - hardcoded here on purpose, same
  # convention as OtpSenderService::TWOFACTOR_API_KEY and R2Service's
  # credentials (not read from ENV).
  OCR_SPACE_API_KEY = "K85495011888957"

  # OCR.space engine 2 is the best all-round choice and is strong on photos of
  # documents on noisy backgrounds (see their "Select the best OCR Engine" docs).
  OCR_ENGINE = "2"
  # Free tier hard limit on the uploaded file.
  MAX_UPLOAD_BYTES = 1_000_000
  # (max dimension, JPEG quality) steps tried in order until the encoded image
  # fits MAX_UPLOAD_BYTES. An ID card stays readable well below the smallest.
  COMPRESSION_STEPS = [ [ 2000, 85 ], [ 1600, 80 ], [ 1200, 75 ], [ 1000, 65 ], [ 800, 55 ] ].freeze

  # file: anything responding to #read (e.g. an ActionDispatch::Http::UploadedFile
  # or its #tempfile) with image bytes - must be called while the upload is
  # still in memory/on disk (i.e. within the original request), not from a
  # later background job.
  def self.extract_text(file)
    new(file).extract_text
  end

  def initialize(file)
    @file = file
  end

  def extract_text
    if OCR_SPACE_API_KEY.blank?
      raise ConfigurationError, "OcrService::OCR_SPACE_API_KEY is not configured"
    end

    uri = URI.parse(OCR_SPACE_ENDPOINT)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.open_timeout = 10
    http.read_timeout = 60

    request = Net::HTTP::Post.new(uri.request_uri)
    request["apikey"] = OCR_SPACE_API_KEY
    request.set_form(
      [
        [ "base64Image", image_data_uri ],
        [ "language", "eng" ],
        [ "OCREngine", OCR_ENGINE ],
        [ "scale", "true" ],
        [ "detectOrientation", "true" ],
        [ "isOverlayRequired", "false" ]
      ],
      "multipart/form-data"
    )

    response = http.request(request)
    body = begin
      JSON.parse(response.body)
    rescue JSON::ParserError
      {}
    end

    unless response.is_a?(Net::HTTPSuccess)
      raise ExtractionError, error_message(body).presence || "OCR.space responded with #{response.code}"
    end

    if body["IsErroredOnProcessing"]
      raise ExtractionError, error_message(body).presence || "OCR.space reported a processing error"
    end

    result = body.dig("ParsedResults", 0)
    if result && result["FileParseExitCode"].to_i != 1
      raise ExtractionError, result["ErrorMessage"].presence || "OCR.space could not parse the document"
    end

    result&.dig("ParsedText").to_s
  rescue ExtractionError, ConfigurationError
    raise
  rescue => e
    raise ExtractionError, e.message
  end

  private

  # OCR.space returns ErrorMessage as either a string or an array of strings.
  def error_message(body)
    Array(body["ErrorMessage"]).flatten.join(", ").presence || body["ErrorDetails"].to_s
  end

  # Returns the upload as a "data:image/jpeg;base64,..." string, auto-oriented
  # and compressed to stay under the free tier's 1 MB cap.
  def image_data_uri
    "data:image/jpeg;base64,#{Base64.strict_encode64(compressed_jpeg)}"
  end

  def compressed_jpeg
    original = read_file_bytes
    last = nil

    COMPRESSION_STEPS.each do |dimension, quality|
      image = MiniMagick::Image.read(original)
      image.combine_options do |c|
        c.auto_orient
        c.strip
        c.resize "#{dimension}x#{dimension}>"
      end
      image.format("jpg") { |c| c.quality quality.to_s }

      last = File.binread(image.path)
      return last if last.bytesize <= MAX_UPLOAD_BYTES
    end

    last
  rescue MiniMagick::Error, MiniMagick::Invalid => e
    # Non-image or unsupported format (e.g. HEIC without a delegate) - fall back
    # to the raw bytes if they already fit, otherwise surface a clear error.
    raw = read_file_bytes
    return raw if raw.bytesize <= MAX_UPLOAD_BYTES
    raise ExtractionError, "Could not process the uploaded image (#{e.message})"
  end

  def read_file_bytes
    io = @file.respond_to?(:tempfile) ? @file.tempfile : @file
    io.rewind if io.respond_to?(:rewind)
    io.read
  end

  # Best-effort field extraction from raw OCR text - not authoritative, only
  # meant to pre-fill the admin review screen alongside the full ocr_text and
  # the card image itself. Number/DOB/gender match fixed, well-defined
  # formats so they're reliable; name/address have no such fixed format and
  # are inferred from nearby label text or position, so they're lower
  # confidence - the admin should always cross-check them against the image
  # before approving.
  module LabelScanner
    # Splits OCR text into trimmed, non-blank lines - both parsers work
    # line-by-line since Vision's fullTextAnnotation text roughly follows the
    # card's printed line breaks.
    def self.lines(text)
      text.to_s.each_line.map(&:strip).reject(&:blank?)
    end

    # Returns the line immediately after one matching label_pattern (e.g. the
    # printed value under a "Name" or "Father's Name" label), or nil if the
    # label isn't found or nothing usable follows it.
    def self.value_after_label(lines, label_pattern)
      idx = lines.index { |l| l.match?(label_pattern) }
      return nil unless idx

      value = lines[idx + 1]
      return nil if value.blank? || value.match?(label_pattern)
      value
    end
  end

  module AadhaarParser
    NUMBER_PATTERN = /\b(\d{4}\s?\d{4}\s?\d{4})\b/
    DOB_PATTERN = /\b(\d{2}\/\d{2}\/\d{4})\b/
    YOB_PATTERN = /Year of Birth\s*[:\-]?\s*(\d{4})/i
    GENDER_PATTERN = /\b(Male|Female|Transgender)\b/i
    ADDRESS_LABEL_PATTERN = /\bAddress\s*[:\-]?\s*/i
    PINCODE_PATTERN = /\b\d{6}\b/
    NOISE_LINE_PATTERN = /government|india|unique|identification|authority|aadhaar|dob|year of birth|male|female|address/i

    def self.parse(text)
      lines = LabelScanner.lines(text)

      {
        "aadhaar_number" => text[NUMBER_PATTERN, 1]&.gsub(/\s+/, " ")&.strip,
        "dob" => text[DOB_PATTERN, 1] || text[YOB_PATTERN, 1],
        "gender" => text[GENDER_PATTERN, 1]&.capitalize,
        "name" => guess_name(lines),
        "address" => guess_address(lines)
      }.compact
    end

    # Aadhaar has no printed "Name:" label - the name is just a standalone
    # line, usually right above the DOB/Year-of-Birth/gender line. Walk
    # upward from there and take the first line that reads like a plain name
    # (letters/spaces only, 2-5 words) and isn't boilerplate card text.
    def self.guess_name(lines)
      anchor = lines.index { |l| l.match?(DOB_PATTERN) || l.match?(YOB_PATTERN) || l.match?(GENDER_PATTERN) }
      return nil unless anchor

      (anchor - 1).downto([anchor - 3, 0].max) do |i|
        candidate = lines[i]
        next if candidate.match?(/\d/) || candidate.match?(NOISE_LINE_PATTERN)
        words = candidate.split(/\s+/)
        return candidate if words.size.between?(2, 5) && candidate.match?(/\A[A-Za-z .]+\z/)
      end
      nil
    end

    # Only fires when the card actually prints an "Address" label (present
    # on the back of a physical Aadhaar / on an e-Aadhaar printout, not on
    # every front-side photo). Captures from the label up to the line with
    # the 6-digit PIN code, since every Aadhaar address ends in one.
    def self.guess_address(lines)
      label_index = lines.index { |l| l.match?(ADDRESS_LABEL_PATTERN) }
      return nil unless label_index

      first_line = lines[label_index].sub(ADDRESS_LABEL_PATTERN, "").strip
      collected = first_line.present? ? [first_line] : []

      (label_index + 1...lines.size).each do |i|
        line = lines[i]
        break if line.match?(/\A(Mobile|VID|Signature|Aadhaar)\b/i)

        collected << line.sub(/,\s*\z/, '')
        break if line.match?(PINCODE_PATTERN) || collected.size >= 6
      end

      collected.join(", ").strip.presence
    end
  end

  module PanParser
    NUMBER_PATTERN = /\b([A-Z]{5}[0-9]{4}[A-Z])\b/
    DOB_PATTERN = /\b(\d{2}\/\d{2}\/\d{4})\b/
    NAME_LABEL_PATTERN = /\ANAME\z/i
    FATHER_NAME_LABEL_PATTERN = /\AFATHER'?S?\s*NAME\z/i

    def self.parse(text)
      upcased = text.upcase
      lines = LabelScanner.lines(text)

      {
        "pan_number" => upcased[NUMBER_PATTERN, 1],
        "dob" => text[DOB_PATTERN, 1],
        "name" => LabelScanner.value_after_label(lines, NAME_LABEL_PATTERN),
        "father_name" => LabelScanner.value_after_label(lines, FATHER_NAME_LABEL_PATTERN)
      }.compact
    end
  end
end
