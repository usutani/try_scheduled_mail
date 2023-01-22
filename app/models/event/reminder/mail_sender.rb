class Event::Reminder::MailSender
  def initialize(mail)
    @mail = mail
  end

  def run
    return unless possible?

    @mail.event.participants.each do |participant|
      MemberMailer.with(member: participant, event: @mail.event).remind.deliver_later
    end
  end

  def possible?
    !canceled? && due?
  end

  def canceled?
    @mail.canceled?
  end

  # イベントの開始日時の1日前以降はtrueを返す。
  def due?
    @mail.event.started_at <= Event::Reminder::REMIND_BEFORE.since
  end
end
