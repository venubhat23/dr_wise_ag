# Search + bulk approve/reject helpers shared by the Affiliate and Ambassador
# KYC review queues (Admin::KycVerificationsController and
# Admin::AmbassadorKycVerificationsController).
module KycQueueTools
  extend ActiveSupport::Concern

  DEFAULT_REJECTION_REASON = 'Documents could not be verified.'.freeze

  private

  # Case-insensitive match on name / email / mobile.
  def apply_kyc_search(scope)
    @q = params[:q].to_s.strip
    return scope if @q.blank?

    table = scope.klass.table_name
    like = "%#{ActiveRecord::Base.sanitize_sql_like(@q)}%"
    scope.where(
      "#{table}.first_name ILIKE :q OR #{table}.last_name ILIKE :q OR #{table}.email ILIKE :q " \
      "OR #{table}.mobile ILIKE :q OR CONCAT_WS(' ', #{table}.first_name, #{table}.last_name) ILIKE :q",
      q: like
    )
  end

  # JSON suggestions for the Select2 search box: the records of `scope` (the
  # current tab, before any search) matching the typed term. The id is the email
  # (or mobile) so picking a suggestion filters the queue down to that record.
  def render_kyc_lookup(scope)
    params[:q] = params[:term]
    matches = apply_kyc_search(scope).order(:first_name, :last_name).limit(30)
    render json: {
      results: matches.map do |r|
        { id: r.email.presence || r.mobile.to_s,
          text: [[r.first_name, r.last_name].compact_blank.join(' ').presence, r.email.presence, r.mobile.presence].compact.join(' · ') }
      end
    }
  end

  # Runs the block for every selected record, isolating failures so one bad
  # record never blocks the rest. The block returns :skip to mark a record
  # as skipped (not eligible for the action).
  # Returns { done:, skipped:, failed: [labels] }.
  def run_bulk(records)
    result = { done: 0, skipped: 0, failed: [] }
    records.each do |record|
      outcome = yield(record)
      outcome == :skip ? result[:skipped] += 1 : result[:done] += 1
    rescue => e
      Rails.logger.error "[KYC bulk] #{record.class.name}##{record.id}: #{e.message}"
      result[:failed] << (record.email.presence || "##{record.id}")
    end
    result
  end

  def bulk_flash(result, verb)
    parts = ["#{result[:done]} #{verb}"]
    parts << "#{result[:skipped]} skipped (not eligible)" if result[:skipped] > 0
    parts << "#{result[:failed].size} failed (#{result[:failed].first(5).join(', ')})" if result[:failed].any?
    parts.join(' · ')
  end
end
