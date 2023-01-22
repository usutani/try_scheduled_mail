require "test_helper"

class EventTest < ActiveSupport::TestCase
  setup do
    @e1 = events(:event1_not_canceled)
    @e2 = events(:event2_canceled)
  end

  test "create event" do
    assert Event.new.invalid?
    assert Event.new(started_at: Time.zone.now).valid?
    e = Event.create(started_at: Time.zone.now)
    assert_equal 1, e.reminder_mails.count
    assert_equal 1, e.reminder_mails.non_canceled.count
  end

  test "update event" do
    e = Event.create(started_at: Time.zone.now)
    e.update(name: "event")
    assert_equal 1, e.reminder_mails.count
    assert_equal 1, e.reminder_mails.non_canceled.count
    e.update(started_at: e.started_at.since(5.days))
    assert_equal 2, e.reminder_mails.count
    assert_equal 1, e.reminder_mails.non_canceled.count
  end

  test "cancel_non_canceled_reminder_mails" do
    assert_equal 2, @e1.reminder_mails.count
    assert_equal 1, @e1.reminder_mails.non_canceled.count
    @e1.cancel_non_canceled_reminder_mails
    assert_equal 2, @e1.reminder_mails.count
    assert_equal 0, @e1.reminder_mails.non_canceled.count

    assert_equal 1, @e2.reminder_mails.count
    assert_equal 1, @e2.reminder_mails.non_canceled.count
    @e2.cancel_non_canceled_reminder_mails
    assert_equal 1, @e2.reminder_mails.count
    assert_equal 0, @e2.reminder_mails.non_canceled.count
  end

  test "cancel" do
    assert_equal 2, @e1.reminder_mails.count
    assert_equal 1, @e1.reminder_mails.non_canceled.count
    @e1.cancel
    assert_equal 2, @e1.reminder_mails.count
    assert_equal 0, @e1.reminder_mails.non_canceled.count

    assert_equal 1, @e2.reminder_mails.count
    assert_equal 1, @e2.reminder_mails.non_canceled.count
    @e2.cancel
    assert_equal 1, @e2.reminder_mails.count
    assert_equal 0, @e2.reminder_mails.non_canceled.count
  end

  test "canceled?" do
    assert_not @e1.canceled?
    assert @e2.canceled?
  end
end
