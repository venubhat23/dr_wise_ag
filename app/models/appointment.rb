class Appointment < ApplicationRecord
  belongs_to :customer, optional: true
  belongs_to :created_by, class_name: 'User', optional: true

  STATUSES = %w[pending confirmed completed cancelled].freeze
  TIME_SLOTS = [
    '09:00 AM', '09:30 AM', '10:00 AM', '10:30 AM',
    '11:00 AM', '11:30 AM', '12:00 PM', '12:30 PM',
    '01:00 PM', '01:30 PM', '02:00 PM', '02:30 PM',
    '03:00 PM', '03:30 PM', '04:00 PM', '04:30 PM',
    '05:00 PM', '05:30 PM', '06:00 PM'
  ].freeze

  after_create_commit :notify_customer_scheduled
  after_update_commit :notify_customer_status_change, if: :saved_change_to_status?

  validates :customer_name, presence: true
  validates :appointment_date, presence: true
  validates :time_slot, presence: true, inclusion: { in: TIME_SLOTS }
  validates :status, inclusion: { in: STATUSES }
  validates :customer_email, format: { with: URI::MailTo::EMAIL_REGEXP }, allow_blank: true

  scope :upcoming, -> { where('appointment_date >= ?', Date.current).order(:appointment_date, :time_slot) }
  scope :past, -> { where('appointment_date < ?', Date.current).order(appointment_date: :desc) }
  scope :for_date, ->(date) { where(appointment_date: date) }
  scope :pending, -> { where(status: 'pending') }
  scope :confirmed, -> { where(status: 'confirmed') }

  def display_time
    "#{appointment_date.strftime('%d %b %Y')} at #{time_slot}"
  end

  def status_color
    case status
    when 'pending'    then 'warning'
    when 'confirmed'  then 'success'
    when 'completed'  then 'info'
    when 'cancelled'  then 'danger'
    else 'secondary'
    end
  end

  def upcoming?
    appointment_date >= Date.current
  end

  private

  def appointment_when
    [appointment_date&.strftime('%d %b %Y'), time_slot].compact.join(' at ')
  end

  def notify_customer_scheduled
    Notification.notify(customer, 'appointment_scheduled', 'Appointment Scheduled',
                        "Your appointment on #{appointment_when} has been scheduled.", self)
  end

  def notify_customer_status_change
    Notification.notify(customer, 'appointment_status_updated', "Appointment #{status.to_s.humanize}",
                        "Your appointment on #{appointment_when} is now #{status.to_s.humanize.downcase}.", self)
  end
end
