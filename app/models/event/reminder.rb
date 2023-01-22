module Event::Reminder
  def self.table_name_prefix
    "event_reminder_"
  end

  extend ActiveSupport::Concern

  REMIND_BEFORE = 1.day

  included do
    after_create :send_mail_later
    after_update :send_mail_later, if: :saved_change_to_started_at_or_canceled_at?
    has_many :reminder_mails, class_name: "Event::Reminder::Mail"
  end

  def saved_change_to_started_at_or_canceled_at?
    saved_change_to_started_at? || saved_change_to_canceled_at?
  end

  def send_mail_later
    cancel_non_canceled_reminder_mails
    return if canceled?
    mail = Event::Reminder::Mail.create event: self
    # TODO Event::Reminder::MailJob.schedule(mail)
    mail
  end

  def cancel_non_canceled_reminder_mails
    reminder_mails.non_canceled.cancel_all
  end
end
