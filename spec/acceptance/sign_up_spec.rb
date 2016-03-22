require 'rails_helper'

feature 'User sign up', %q{
  In order to be able to sign up
  As an anonymous user
  I want to be able to register
} do

  scenario 'Anonymous user try to sign up' do
    visit new_user_registration_path
    fill_in 'Email', with: 'user@test.com'
    fill_in 'Password', with: '12345678'
    fill_in 'Password confirmation', with: '12345678'
    click_on 'Sign up'

    expect(page).to have_content 'Welcome! You have signed up successfully.'
    expect(current_path).to eq root_path
  end

end