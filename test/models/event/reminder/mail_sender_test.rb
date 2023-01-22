require "test_helper"

class Event::Reminder::MailSenderTest < ActiveSupport::TestCase
  test "due?" do
    e1m1 = event_reminder_mails(:event1_not_canceled__mail1_canceled)
    ms = Event::Reminder::MailSender.new(e1m1)

    travel_to(e1m1.event.started_at.prev_month)
    assert_not ms.due?, "開始日時の一ヶ月前: 期限前"

    travel_to(e1m1.event.started_at.prev_day(2))
    assert_not ms.due?, "開始日時の前々日: 期限前"

    travel_to(e1m1.event.started_at.prev_day - 1.second)
    ms = Event::Reminder::MailSender.new(e1m1)
    assert_not ms.due?, "開始日時の前日の1秒前: 期限前"

    travel_to(e1m1.event.started_at.prev_day)
    ms = Event::Reminder::MailSender.new(e1m1)
    assert ms.due?, "開始日時の前日: 期限後: 以降期限後になる"

    travel_to(e1m1.event.started_at)
    assert ms.due?, "開始日時当日: 期限後"

    travel_to(e1m1.event.started_at.next_day)
    assert ms.due?, "開始日時の翌日: 期限後"

    travel_to(e1m1.event.started_at.next_month)
    assert ms.due?, "開始日時の一ヶ月後: 期限後"
  end

  test "canceled?" do
    e1m1 = event_reminder_mails(:event1_not_canceled__mail1_canceled)
    assert e1m1.canceled?, "メール送信はキャンセル済み"
    e1m2 = event_reminder_mails(:event1_not_canceled__mail2_not_canceled)
    assert_not e1m2.canceled?
    e2m1 = event_reminder_mails(:event1_not_canceled__mail2_not_canceled)
    assert_not e2m1.canceled?
  end

  test "possible?" do
    e1m1 = event_reminder_mails(:event1_not_canceled__mail1_canceled)
    ms1 = Event::Reminder::MailSender.new(e1m1)
    travel_to(e1m1.event.started_at.prev_day(2))
    assert_not ms1.possible?, "メール送信は不可能"
    travel_to(e1m1.event.started_at.prev_day)
    assert_not ms1.possible?, "メール送信は不可能"

    e1m2 = event_reminder_mails(:event1_not_canceled__mail2_not_canceled)
    ms2 = Event::Reminder::MailSender.new(e1m2)
    travel_to(e1m2.event.started_at.prev_day(2))
    assert_not ms2.possible?, "メール送信は不可能"
    travel_to(e1m2.event.started_at.prev_day)
    assert ms2.possible?
  end

  test "event1_not_canceled__mail1_canceled" do
    e1m1 = event_reminder_mails(:event1_not_canceled__mail1_canceled)
    assert e1m1.canceled?, "メール送信はキャンセル済み"
    ms = Event::Reminder::MailSender.new(e1m1)
    travel_to(e1m1.event.started_at.prev_day)
    assert_not ms.possible?, "メール送信は不可能"
    assert_nil ms.run
  end

  test "event1_not_canceled__mail2_not_canceled" do
    e1m2 = event_reminder_mails(:event1_not_canceled__mail2_not_canceled)
    assert_not e1m2.canceled?
    ms = Event::Reminder::MailSender.new(e1m2)
    travel_to(e1m2.event.started_at.prev_day)
    assert ms.possible?
    assert ms.run
  end

  test "event2_canceled__mail1_not_canceled" do
    e2m1 = event_reminder_mails(:event1_not_canceled__mail2_not_canceled)
    assert_not e2m1.canceled?
    ms = Event::Reminder::MailSender.new(e2m1)
    travel_to(e2m1.event.started_at.prev_day)
    assert ms.possible? # MailSenderはイベントがキャンセル済みかどうかを関知しない。
    assert ms.run
  end
end
