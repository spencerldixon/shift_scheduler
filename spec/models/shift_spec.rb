require 'rails_helper'

RSpec.describe Shift, type: :model do
  let(:monday)      { DateTime.now.monday }
  let(:two_am)      { monday.change(hour: 2) }
  let(:five_am)     { monday.change(hour: 5) }
  let(:nine_am)     { monday.change(hour: 9) }
  let(:start_time)  { nine_am }
  let(:end_time)    { monday.change(hour: 17) }
  let(:shift)       { FactoryBot.build(:shift, start_time: start_time, end_time: end_time) }

  describe "validations" do
    it "requires a start time" do
      shift.start_time = nil

      expect(shift).to_not be_valid
    end

    it "requires an end time" do
      shift.end_time = nil

      expect(shift).to_not be_valid
    end

    it "requires a user" do
      shift.user = nil

      expect(shift).to_not be_valid
    end

    it "requires end time is after start time" do
      inverted_shift = FactoryBot.build(
        :shift,
        start_time: end_time,
        end_time: start_time
      )

      expect(inverted_shift).to_not be_valid
    end

    it "cannot exceed 8 hours in duration" do
      overtime_shift = FactoryBot.build(
        :shift,
        start_time: start_time,
        end_time: start_time + 10.hours
      )

      expect(overtime_shift).to_not be_valid
    end

    it "cannot overlap another shift" do
      FactoryBot.create(
        :shift,
        start_time: start_time,
        end_time: end_time
      )

      overlapping_shift = FactoryBot.build(
        :shift,
        start_time: start_time + 2.hour,
        end_time: end_time + 2.hour
      )

      expect(overlapping_shift).to_not be_valid
    end

    it "requires start_time to be within opening hours" do
      out_of_hours_start = FactoryBot.build(
        :shift,
        start_time: five_am,
        end_time: nine_am
      )

      expect(out_of_hours_start).to_not be_valid
    end

    it "requires end_time to be within opening hours" do
      out_of_hours_end = FactoryBot.build(
        :shift,
        start_time: two_am,
        end_time: five_am
      )

      expect(out_of_hours_end).to_not be_valid
    end

    it "cannot exceed 40 hours in total per week" do
      user = FactoryBot.create(:user)

      5.times do |n|
        FactoryBot.create(
          :shift,
          user: user,
          start_time: start_time + n.days,
          end_time: end_time + n.days
        )
      end

      fifth_consecutive_shift = FactoryBot.build(
        :shift,
        user: user,
        start_time: start_time + 6.days,
        end_time: end_time + 6.days
      )

      expect(fifth_consecutive_shift).to_not be_valid
    end
  end

  describe "#duration" do
    it "returns duration in hours between the start and end times" do
      five_hour_shift = FactoryBot.build(
        :shift,
        start_time: start_time,
        end_time: start_time + 5.hours
      )

      expect(five_hour_shift.duration).to eq(5)
    end
  end
end
