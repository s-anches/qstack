require_relative '../../../acceptance_helper'

feature 'User sign in with GitHub OAuth', %q{
  In order to be able to sign in
  As an anonymous user
  I want to be able to sign in as GitHub account
} do

  describe 'User try to sign in' do
    before { visit new_user_session_path }

    describe 'with valid credentials' do
      scenario 'if email present' do
        mock_auth_hash(:github, "user@example.com")
        click_link "Sign in with GitHub"

        expect(page).to have_content("user@example.com")
        expect(page).to have_link("Sign out")
      end

      scenario 'if email not present' do
        mock_auth_hash(:github)
        click_on 'Sign in with GitHub'

        fill_in 'user_email', with: 'user@example.com'
        click_on 'Continue'
        open_email('user@example.com')
        current_email.click_link 'Confirm my account'

        expect(page).to have_content("Your email address has been successfully confirmed.")
      end
    end

    scenario 'with invalid credentials' do
      OmniAuth.config.mock_auth[:github] = :invalid_credentials
      click_link "Sign in with GitHub"

      expect(page).to have_content("Could not authenticate you! Invalid credential!")
      expect(current_path).to eq new_user_registration_path
    end
  end
end
