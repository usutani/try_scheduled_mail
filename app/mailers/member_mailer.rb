class MemberMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.member_mailer.remind.subject
  #
  def remind
    @greeting = "Hi"

    mail to: "to@example.org"
  end
end
