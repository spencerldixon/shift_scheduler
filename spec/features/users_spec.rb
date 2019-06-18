require 'rails_helper'

RSpec.feature "Users", type: :feature do
  let(:user)        { FactoryBot.create(:user) }

  feature "authentication" do
    scenario "can log in" do
      visit root_path
      click_link "Sign in"
      fill_in "Email",    with: user.email
      fill_in "Password", with: user.password
      click_button "Log in"

      expect(page).to have_text("Signed in successfully")
    end

    scenario "can log out" do
      sign_in user
      visit root_path
      click_link "Sign out"
      expect(page).to have_text("Signed out successfully")
    end
  end
end


