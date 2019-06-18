require 'rails_helper'

RSpec.describe Shift, type: :model do
  let(:start_time)  { DateTime.now.change(hour: 9) }
  let(:end_time)    { DateTime.now.change(hour: 17) }
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

    it "cannot overlap another shift"
    it "is within the boundaries of 7am to 3am opening hours"
    # cannot overlap the 3:00:01am to 6:59:59am slot

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
end
