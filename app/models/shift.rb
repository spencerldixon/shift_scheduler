class Shift < ApplicationRecord
  OPENING_HOURS = Time.parse('7:00')
  CLOSING_HOURS = Time.parse('3:00')

  belongs_to :user

  validates :start_time, :end_time, :user, presence: true
  validate :end_must_be_after_start
  validate :cannot_exceed_maximum_duration
  validate :cannot_overlap_another_shift
  validate :start_time_is_within_working_hours
  validate :end_time_is_within_working_hours

  scope :in_range, -> (range) {
    where(
      '(start_time BETWEEN ? AND ? OR end_time BETWEEN ? AND ?) OR (start_time <= ? AND end_time >= ?)',
      range.first,
      range.last,
      range.first,
      range.last,
      range.first,
      range.last
    )
  }

  # def self.available(date)
  # end

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

    def cannot_exceed_maximum_duration
      return if [start_time, end_time].any?(&:blank?)

      if duration > 8
        errors.add(:end_time, "cannot exceed maximum duration of 8 hours")
      end
    end

    def cannot_overlap_another_shift
      return if [start_time, end_time].any?(&:blank?)

      range    = (start_time + 1.second)..(end_time - 1.second)
      overlaps = Shift.in_range(range)

      if overlaps.any?
        errors.add(:end_time, "cannot overlap another shift")
      end
    end

    def start_time_is_within_working_hours
      return if start_time.blank?

      if start_time.between?(CLOSING_HOURS, OPENING_HOURS)
        errors.add(:start_time, "start time must be within working hours of 7am - 3am")
      end
    end

    def end_time_is_within_working_hours
      return if end_time.blank?

      if end_time.between?(CLOSING_HOURS, OPENING_HOURS)
        errors.add(:end_time, "end time must be within working hours of 7am - 3am")
      end
    end
end
