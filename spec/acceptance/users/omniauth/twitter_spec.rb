require_relative '../../../acceptance_helper'

feature 'User sign in with Twitter OAuth', %q{
  In order to be able to sign in
  As an anonymous user
  I want to be able to sign in as Twitter account
} do

  describe 'User try to sign in' do
    before { visit new_user_session_path }

    describe 'with valid credentials' do
      scenario 'if email present' do
        mock_auth_hash(:twitter, "user@example.com")
        click_link "Sign in with Twitter"

        expect(page).to have_content("user@example.com")
        expect(page).to have_link("Sign out")
      end

      scenario 'if email not present' do
        mock_auth_hash(:twitter)
        click_on 'Sign in with Twitter'

        fill_in 'user_email', with: 'user@example.com'
        click_on 'Continue'
        open_email('user@example.com')
        current_email.click_link 'Confirm my account'

        expect(page).to have_content("Your email address has been successfully confirmed.")
      end
    end

    scenario 'with invalid credentials' do
      OmniAuth.config.mock_auth[:twitter] = :invalid_credentials
      click_on 'Sign in with Twitter'

      expect(page).to have_content("Could not authenticate you! Invalid credential!")
      expect(current_path).to eq new_user_registration_path
    end

  end
end
