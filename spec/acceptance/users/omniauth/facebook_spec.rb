require_relative '../../../acceptance_helper'

feature 'User sign in with Facebook OAuth', %q{
  In order to be able to sign in
  As an anonymous user
  I want to be able to sign in as Facebook account
} do

  describe 'User try to sign in' do
    before { visit new_user_session_path }

    scenario 'with valid credentials' do
      mock_auth_hash
      click_link "Sign in with Facebook"

      expect(page).to have_content("mockuser@mock.com")
      expect(page).to have_link("Sign out")
    end

    scenario 'with invalid credentials' do
      OmniAuth.config.mock_auth[:facebook] = :invalid_credentials
      click_link "Sign in with Facebook"

      expect(page).to have_content('Could not authenticate you from Facebook because "Invalid credentials"')
    end
  end
end
