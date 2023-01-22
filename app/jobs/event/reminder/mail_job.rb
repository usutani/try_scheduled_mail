class Event::Reminder::MailJob < ApplicationJob
  queue_as :reminder_mail

  def self.schedule(mail)
    set(wait_until: mail.will_send_mail_at).perform_later(mail)
  end

  def perform(mail)
    mail.send_mail
  end
end
