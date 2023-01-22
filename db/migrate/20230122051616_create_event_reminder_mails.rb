class CreateEventReminderMails < ActiveRecord::Migration[7.0]
  def change
    create_table :event_reminder_mails do |t|
      t.belongs_to :event, null: false, foreign_key: true
      t.datetime :canceled_at

      t.timestamps
    end
  end
end
