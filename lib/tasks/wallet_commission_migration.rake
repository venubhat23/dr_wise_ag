namespace :wallet do
  # Dry run (default):  bin/rails wallet:migrate_affiliate_commissions
  # One affiliate:      bin/rails wallet:migrate_affiliate_commissions SUB_AGENT_ID=15
  # Write for real:     bin/rails wallet:migrate_affiliate_commissions APPLY=1
  desc 'Move affiliate commission into wallets (unpaid -> active balance, paid shown as already paid)'
  task migrate_affiliate_commissions: :environment do
    CommissionWalletMigration.new(
      role: :affiliate,
      dry_run: ENV['APPLY'] != '1',
      owner_id: ENV['SUB_AGENT_ID'].presence&.to_i
    ).call
  end

  # Same options, with DISTRIBUTOR_ID to limit it to one ambassador.
  desc 'Move ambassador commission into wallets (unpaid -> active balance, paid shown as already paid)'
  task migrate_ambassador_commissions: :environment do
    CommissionWalletMigration.new(
      role: :ambassador,
      dry_run: ENV['APPLY'] != '1',
      owner_id: ENV['DISTRIBUTOR_ID'].presence&.to_i
    ).call
  end
end
