require "test_helper"

class Event::Reminder::MailTest < ActiveSupport::TestCase
  test "will_send_mail_at" do
    e1m1 = event_reminder_mails(:event1_not_canceled__mail1_canceled)
    assert_equal e1m1.event.started_at - 1.day, e1m1.will_send_mail_at
  end

  test "canceled?" do
    e1m1 = event_reminder_mails(:event1_not_canceled__mail1_canceled)
    assert e1m1.canceled?
    e1m2 = event_reminder_mails(:event1_not_canceled__mail2_not_canceled)
    assert_not e1m2.canceled?
    e2m1 = event_reminder_mails(:event2_canceled__mail1_not_canceled)
    assert_not e2m1.canceled?
  end
end
