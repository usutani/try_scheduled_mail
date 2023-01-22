require "test_helper"

class Event::Reminder::MailJobTest < ActiveJob::TestCase
  test "self.schedule(mail)" do
    assert_enqueued_jobs 0
    e1m1 = event_reminder_mails(:event1_not_canceled__mail1_canceled)
    Event::Reminder::MailJob.schedule(e1m1)
    assert_enqueued_jobs 1
    e1m2 = event_reminder_mails(:event1_not_canceled__mail2_not_canceled)
    Event::Reminder::MailJob.schedule(e1m2)
    assert_enqueued_jobs 2 # メールがキャンセル済みかどうかを関知しない。
    e2m1 = event_reminder_mails(:event2_canceled__mail1_not_canceled)
    Event::Reminder::MailJob.schedule(e2m1)
    assert_enqueued_jobs 3 # イベントがキャンセル済みかどうかを関知しない。
  end
end
