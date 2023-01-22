class Event::Reminder::Mail < ApplicationRecord
  belongs_to :event

  scope :non_canceled, -> { where(canceled_at: nil) }

  # イベントの開始日時の1日前
  def will_send_mail_at
    event.started_at - Event::Reminder::REMIND_BEFORE
  end

  def send_mail
    Event::Reminder::MailSender.new(self).run
  end

  def self.cancel_all
    update_all(canceled_at: Time.zone.now)
  end

  def canceled?
    !!canceled_at
  end
end
