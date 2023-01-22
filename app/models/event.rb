class Event < ApplicationRecord
  include Event::Reminder

  validates :started_at, presence: true

  has_many :schedules
  has_many :participants, through: :schedules, source: :member

  def cancel
    update(canceled_at: Time.zone.now)
  end

  def canceled?
    !!canceled_at
  end
end
