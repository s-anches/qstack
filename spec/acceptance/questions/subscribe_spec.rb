require_relative '../../acceptance_helper'

feature 'User can subscribe for question', %q{
  In order to be able get notifications
  As an authenticated user
  I want to subscribe for question
} do

  given(:user) { create(:user) }
  given(:question) { create(:question) }

  describe 'Authenticated user' do

    before do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'can subscribe', js: true do
      click_on 'Subscribe'

      expect(page).to have_content('You subscribed for this question.')
    end
  end

  describe 'Non-authenticated user' do
    scenario 'can not subscribe' do
      expect(page).to_not have_link('Subscribe')
    end
  end

end