# A membership period an ambassador / affiliate paid before subscriptions were
# tracked in the app (entered by admin). History only: it never affects
# subscription status or blocking - see Subscribable for the live ones.
class OlderSubscription < ApplicationRecord
  belongs_to :subscriber, polymorphic: true

  validates :starts_on, :ends_on, presence: true
  validates :amount, numericality: { greater_than_or_equal_to: 0 }
  validate :ends_after_start

  def as_api_json
    {
      id: id,
      from: starts_on,
      to: ends_on,
      amount: amount.to_f,
      paid_on: paid_on,
      note: notes
    }
  end

  private

  def ends_after_start
    errors.add(:ends_on, 'must be on or after the From date') if starts_on && ends_on && ends_on < starts_on
  end
end
