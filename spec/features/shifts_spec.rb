require 'rails_helper'

RSpec.feature "Shifts", type: :feature do
  let(:user) { FactoryBot.create(:user) }
  let(:start_time) { DateTime.now.change(hour: 9) }
  let(:end_time) { DateTime.now.change(hour: 17) }

  scenario "can view my shifts" do
    sign_in user
    visit root_path
    click_link "Shifts"

    expect(page).to have_text("My Shifts")
  end

  scenario "can view a single shift" do
    user = FactoryBot.create(:user, :with_shifts)
    sign_in user
    visit shifts_path
    click_link("Show", match: :first)

    expect(current_path).to eq(shift_path(user.shifts.first.id))
  end

  scenario "can create a shift" do
    sign_in user
    visit shifts_path
    click_link "New Shift"

    expect(page).to have_text("Book a new shift")

    expect {
      select start_time.year.to_s,      from: 'shift_start_time_1i'
      select start_time.strftime("%B"), from: 'shift_start_time_2i'
      select start_time.day.to_s,       from: 'shift_start_time_3i'
      select start_time.strftime("%H"), from: 'shift_start_time_4i'
      select "00",                      from: 'shift_start_time_5i'

      select end_time.year.to_s,        from: 'shift_end_time_1i'
      select end_time.strftime("%B"),   from: 'shift_end_time_2i'
      select end_time.day.to_s,         from: 'shift_end_time_3i'
      select end_time.strftime("%H"),   from: 'shift_end_time_4i'
      select "00",                      from: 'shift_end_time_5i'

      click_button "Create Shift"

    }.to change(Shift, :count).by(+1)

    expect(page).to have_text("Your shift was booked successfully")
  end
end
