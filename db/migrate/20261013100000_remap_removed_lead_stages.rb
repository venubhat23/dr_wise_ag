# Lead flow is now: Lead Generated → Consultation → One on One → Follow-up →
# Proposal/Quote → Payment Made → Underwriting → Converted (see Lead::STAGES).
# Move leads sitting on removed stages onto the new flow so they stay valid.
class RemapRemovedLeadStages < ActiveRecord::Migration[8.0]
  STAGE_REMAP = {
    'follow_up_successful'   => 'follow_up',
    'follow_up_unsuccessful' => 'follow_up',
    're_follow_up'           => 'follow_up',
    'not_interested'         => 'follow_up',
    'lead_closed'            => 'follow_up',
    'consultation'           => 'consultation_scheduled',
    'policy_created'         => 'converted',
    'referral_settled'       => 'converted'
  }.freeze

  def up
    STAGE_REMAP.each do |old_stage, new_stage|
      execute <<~SQL
        UPDATE leads SET current_stage = #{quote(new_stage)}, updated_at = NOW()
        WHERE current_stage = #{quote(old_stage)}
      SQL
    end
  end

  def down
    # Irreversible data remap — the original stage of each lead is not kept.
  end

  private

  def quote(value)
    ActiveRecord::Base.connection.quote(value)
  end
end
