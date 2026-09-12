class ReclassifyRegisteredAmbassadorsAsPending < ActiveRecord::Migration[8.0]
  # Ambassador self-registration used to jump straight to kyc_status: submitted,
  # so the "Awaiting Review" queue was full of accounts that had not actually
  # submitted any KYC. There is no ambassador KYC-submission step yet, so every
  # self-registered ambassador that has never been reviewed is really just
  # "Registered" — move them to kyc_status: pending so they show under the new
  # "Registered" tab instead of "Awaiting Review".
  def up
    execute <<~SQL
      UPDATE distributors
         SET kyc_status = 0,
             kyc_submitted_at = NULL
       WHERE self_registered = TRUE
         AND kyc_status = 1
         AND kyc_reviewed_at IS NULL
    SQL
  end

  def down
    # Not reversible in a meaningful way (we can't tell which rows to move back).
  end
end
