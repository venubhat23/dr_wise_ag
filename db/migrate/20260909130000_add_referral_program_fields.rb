class AddReferralProgramFields < ActiveRecord::Migration[8.0]
  def up
    add_column :distributors, :referral_code, :string
    add_column :sub_agents,  :referral_code, :string
    add_column :sub_agents,  :referred_by_code, :string
    add_column :sub_agents,  :referred_by_kind, :string # 'ambassador' | 'affiliate'
    add_column :sub_agents,  :referral_bonus_credited_at, :datetime

    add_index :distributors, :referral_code, unique: true
    add_index :sub_agents,  :referral_code, unique: true

    # Backfill referral codes for existing records.
    say_with_time 'Backfilling ambassador referral codes' do
      Distributor.reset_column_information
      Distributor.where(referral_code: nil).find_each do |d|
        d.update_columns(referral_code: unique_code('AMB', Distributor))
      end
    end

    say_with_time 'Backfilling affiliate referral codes' do
      SubAgent.reset_column_information
      SubAgent.where(referral_code: nil).find_each do |s|
        s.update_columns(referral_code: unique_code('AFF', SubAgent))
      end
    end
  end

  def down
    remove_index :distributors, :referral_code
    remove_index :sub_agents,  :referral_code
    remove_column :distributors, :referral_code
    remove_column :sub_agents,  :referral_code
    remove_column :sub_agents,  :referred_by_code
    remove_column :sub_agents,  :referred_by_kind
    remove_column :sub_agents,  :referral_bonus_credited_at
  end

  private

  def unique_code(prefix, klass)
    loop do
      candidate = "#{prefix}#{SecureRandom.random_number(100_000..999_999)}"
      return candidate unless klass.exists?(referral_code: candidate)
    end
  end
end
