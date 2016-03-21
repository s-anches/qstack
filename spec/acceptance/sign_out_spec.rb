require 'rails_helper'

feature 'User sign out', %q{
  In order to be able to sign out
  As an authenticated user
  I want to be able to sign out
} do

  scenario 'Registered user try to sign out' do
    User.create!(email: 'user@test.com', password: '12345678')

    visit root_path
    click_on 'Sign in'
    fill_in 'Email', with: 'user@test.com'
    fill_in 'Password', with: '12345678'
    click_on 'Log in'

    expect(page).to have_content 'Signed in successfully.'
    expect(current_path).to eq root_path

    expect(page).to_not have_link 'Sign in'

    click_on 'Sign out'
    expect(page).to have_content 'Signed out successfully.'
    expect(current_path).to eq root_path

    expect(page).to_not have_link 'Sign out'
  end

end