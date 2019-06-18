class Shift < ApplicationRecord
  belongs_to :user

  validates :start_time, :end_time, :user, presence: true
  validate :end_must_be_after_start
  validate :maximum_duration

  # def self.available(date)
  # end
#
  def duration
    (end_time.to_time - start_time.to_time) / 1.hour
  end

  private
    def end_must_be_after_start
      return if [start_time, end_time].any?(&:blank?)

      if start_time > end_time
        errors.add(:end_time, "must be after start time")
      end
    end

    def maximum_duration
      return if [start_time, end_time].any?(&:blank?)

      if duration > 8
        errors.add(:end_time, "must be after start time")
      end
    end
end
