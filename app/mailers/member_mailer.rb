class MemberMailer < ApplicationMailer
  def remind
    member = params[:member]
    return if member.deactivated?
    event = params[:event]
    return if event.canceled?

    @event_name = event.name
    @event_started_at = I18n.l(event.started_at, format: :mail_subject)
    mail to: member.email, subject: "#{@event_name}: #{@event_started_at}"
  end
end
