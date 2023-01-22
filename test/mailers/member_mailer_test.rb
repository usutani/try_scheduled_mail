require "test_helper"

class MemberMailerTest < ActionMailer::TestCase
  # 会員がアクティブかつイベントがキャンセル済みでなければメール送信できる
  test "remind_m1_e1" do
    m1 =  members(:member1_not_deactivated)
    e1 = events(:event1_not_canceled)
    mail = MemberMailer.with(member: m1, event: e1).remind
    assert_equal "event1_not_canceled: 2023/01/10 12:23", mail.subject
    assert_equal ["member1_not_deactivated@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "event_name: event1_not_canceled", mail.body.encoded
    assert_match "event_started_at: 2023/01/10 12:23", mail.body.encoded
    assert_emails 1 do
      mail.deliver_now
    end
  end

  test "remind_m1_e2" do
    m1 =  members(:member1_not_deactivated)
    e2 = events(:event2_canceled)
    mail = MemberMailer.with(member: m1, event: e2).remind
    assert_blank_and_not_delivered(mail)
  end

  test "remind_m2_e1" do
    m2 =  members(:member2_deactivated)
    e1 = events(:event1_not_canceled)
    mail = MemberMailer.with(member: m2, event: e1).remind
    assert_blank_and_not_delivered(mail)
  end

  test "remind_m2_e2" do
    m2 =  members(:member2_deactivated)
    e2 = events(:event2_canceled)
    mail = MemberMailer.with(member: m2, event: e2).remind
    assert_blank_and_not_delivered(mail)
  end

  private
    def assert_blank_and_not_delivered(mail)
      assert_nil mail.subject
      assert_nil mail.to
      assert_nil mail.from
      assert_equal "", mail.body
      assert_emails 0 do
        mail.deliver_now
      end
    end
end
