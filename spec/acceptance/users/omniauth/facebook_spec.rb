require_relative '../../../acceptance_helper'

feature 'User sign in with Facebook OAuth', %q{
  In order to be able to sign in
  As an anonymous user
  I want to be able to sign in as Facebook account
} do

  describe 'User try to sign in' do
    before { visit new_user_session_path }

    describe 'with valid credentials' do
      scenario 'if email present' do
        mock_auth_hash(:facebook, "user@example.com")
        click_link "Sign in with Facebook"

        expect(page).to have_content("user@example.com")
        expect(page).to have_link("Sign out")
      end

      scenario 'if email not present' do
        mock_auth_hash(:facebook)
        click_on 'Sign in with Facebook'

        fill_in 'user_email', with: 'user@example.com'
        click_on 'Continue'
        open_email('user@example.com')
        current_email.click_link 'Confirm my account'

        expect(page).to have_content("Your email address has been successfully confirmed.")
      end
    end

    scenario 'with invalid credentials' do
      OmniAuth.config.mock_auth[:facebook] = :invalid_credentials
      click_link "Sign in with Facebook"

      expect(page).to have_content("Could not authenticate you! Invalid credential!")
      expect(current_path).to eq new_user_registration_path
    end
  end
end
