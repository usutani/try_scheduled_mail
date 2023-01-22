# Preview all emails at http://localhost:3000/rails/mailers/member_mailer
class MemberMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/member_mailer/remind
  def remind
    m = Member.new(email: "foo@example.org")
    e = Event.new(started_at: Time.zone.now)
    MemberMailer.with(member: m, event: e).remind
  end
end
