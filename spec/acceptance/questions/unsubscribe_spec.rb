require_relative '../../acceptance_helper'

feature 'User can unsubscribe for question', %q{
  In order to be able off notifications
  As an authenticated user
  I want to unsubscribe for question
} do

  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given!(:subscription) { user.subscribe(question) }

  describe 'Authenticated user' do
    before do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'can subscribe', js: true do
      click_on 'Unsubscribe'

      expect(page).to have_content('You unsubscribed for this question.')
    end
  end

  describe 'Non-authenticated user' do
    scenario 'can not subscribe' do
      expect(page).to_not have_link('Unsubscribe')
    end
  end

end