require 'rails_helper'

RSpec.describe Shift, type: :model do
  let(:user)          { FactoryBot.create(:user) }
  let(:monday)        { DateTime.now.monday }
  let(:tuesday)       { DateTime.now.monday + 1.day }
  let(:monday_start)  { monday.change(hour: 9) }
  let(:monday_end)    { monday.change(hour: 17) }
  let(:tuesday_start) { tuesday.change(hour: 9) }
  let(:tuesday_end)   { tuesday.change(hour: 17) }

  let(:shift_1) { FactoryBot.create(
    :shift,
    user: user,
    start_time: monday_start,
    end_time: monday_end)
  }

  let(:shift_2) { FactoryBot.create(
    :shift,
    user: user,
    start_time: tuesday_start,
    end_time: tuesday_end)
  }

  describe '#weekly_hours(date)' do
    it 'returns the total shift hours for a given week' do
      shift_1
      shift_2

      expect(user.weekly_hours(monday)).to eq(16)
    end
  end
end
