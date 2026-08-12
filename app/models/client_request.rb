class ClientRequest < ApplicationRecord
  include PgSearch::Model

  # Associations
  belongs_to :resolved_by, class_name: 'User', optional: true
  belongs_to :submitter, polymorphic: true, optional: true
  has_many :notifications, as: :reference, dependent: :destroy

  # Validations
  validates :name, presence: true
  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :phone_number, presence: true
  validates :description, presence: true
  validates :status, presence: true, inclusion: { in: %w[pending in_progress resolved closed] }
  validates :priority, presence: true, inclusion: { in: %w[low medium high urgent] }
  validates :submitted_at, presence: true

  # Enums
  STATUSES = %w[pending in_progress resolved closed].freeze
  PRIORITIES = %w[low medium high urgent].freeze
  CATEGORIES = %w[general policy_inquiry claims technical_support billing other].freeze

  # Scopes
  scope :pending, -> { where(status: 'pending') }
  scope :in_progress, -> { where(status: 'in_progress') }
  scope :resolved, -> { where(status: 'resolved') }
  scope :closed, -> { where(status: 'closed') }
  scope :by_priority, ->(priority) { where(priority: priority) }
  scope :recent, -> { order(submitted_at: :desc) }

  # Search
  pg_search_scope :search_requests,
    against: [:name, :email, :phone_number, :description, :admin_response],
    using: {
      tsearch: {
        prefix: true,
        any_word: true
      }
    }

  # Callbacks
  before_validation :set_submitted_at, on: :create
  before_validation :generate_ticket_number, on: :create
  before_update :set_resolved_at
  after_update :create_admin_response_notification
  after_commit :clear_dashboard_stats_cache

  # Dashboard stat cards previously ran 5 separate COUNT queries. Combine
  # them into one grouped query, cached briefly and invalidated on write.
  def self.dashboard_stats(expires_in: 5.minutes)
    Rails.cache.fetch('client_requests/dashboard_stats', expires_in: expires_in) do
      counts = group(:status).count
      {
        total: counts.values.sum,
        pending: counts['pending'].to_i,
        in_progress: counts['in_progress'].to_i,
        resolved: counts['resolved'].to_i,
        closed: counts['closed'].to_i
      }
    end
  end

  # Instance methods
  def status_badge_class
    case status
    when 'pending'
      'badge-warning'
    when 'in_progress'
      'badge-info'
    when 'resolved'
      'badge-success'
    when 'closed'
      'badge-secondary'
    else
      'badge-light'
    end
  end

  def priority_badge_class
    case priority
    when 'low'
      'badge-light'
    when 'medium'
      'badge-primary'
    when 'high'
      'badge-warning'
    when 'urgent'
      'badge-danger'
    else
      'badge-light'
    end
  end

  def days_since_submission
    (Date.current - submitted_at.to_date).to_i
  end

  def resolved?
    %w[resolved closed].include?(status)
  end

  private

  def clear_dashboard_stats_cache
    Rails.cache.delete('client_requests/dashboard_stats')
  end

  def set_submitted_at
    self.submitted_at ||= Time.current
  end

  def generate_ticket_number
    return if ticket_number.present?

    # Generate ticket number in format: TKT-YYYYMMDD-XXXX
    date_part = Date.current.strftime('%Y%m%d')

    # Find the last ticket number for today
    last_ticket = ClientRequest.where("ticket_number LIKE ?", "TKT-#{date_part}-%")
                              .order(:ticket_number)
                              .last

    if last_ticket && last_ticket.ticket_number.match(/TKT-#{date_part}-(\d{4})/)
      sequence = $1.to_i + 1
    else
      sequence = 1
    end

    self.ticket_number = "TKT-#{date_part}-#{sequence.to_s.rjust(4, '0')}"
  end

  def set_resolved_at
    if status_changed? && resolved?
      self.resolved_at = Time.current
    elsif status_changed? && !resolved?
      self.resolved_at = nil
    end
  end

  def create_admin_response_notification
    # Only create notification if admin_response was added or changed
    if saved_change_to_admin_response? && admin_response.present? && submitter.present?
      Notification.create_helpdesk_comment_notification(self, submitter)
    end
  end
end
