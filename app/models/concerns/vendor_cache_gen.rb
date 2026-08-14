# Shared writer for the "vendor_cache_gen" cache-busting key, used by several
# models' after_commit callbacks (Vendor, VendorProduct, VendorPayout, Lead,
# ClientService). Writing this key is itself a DB round trip (solid_cache),
# so saving N related records (e.g. N vendor products in one form submit)
# used to mean N separate writes. Throttling collapses any burst of bumps
# within the window into a single write — correctness only needs the key to
# change at least once after a burst, not once per record.
module VendorCacheGen
  THROTTLE_SECONDS = 0.5
  MUTEX = Mutex.new

  def self.bump!
    return if recently_bumped?

    MUTEX.synchronize do
      return if recently_bumped?

      Rails.cache.write("vendor_cache_gen", SecureRandom.hex(4))
      @last_bumped_at = Process.clock_gettime(Process::CLOCK_MONOTONIC)
    end
  rescue => e
    Rails.logger.warn "Failed to bump vendor_cache_gen: #{e.message}"
  end

  def self.recently_bumped?
    @last_bumped_at && (Process.clock_gettime(Process::CLOCK_MONOTONIC) - @last_bumped_at) < THROTTLE_SECONDS
  end
end
