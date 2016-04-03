require_relative '../../acceptance_helper'

feature 'User can vote for question', %q{
  In order to be able up/down rating of question
  As an authenticated user
  I want to vote for question
} do

  given(:user) { create(:user) }
  given(:user_two) { create(:user) }
  given(:own_question) { create(:question, user: user) }
  given(:foreign_question) { create(:question) }

  describe 'Authenticated user' do

    before do
      sign_in(user)
      visit question_path(foreign_question)
    end

    scenario 'can like foreign question', js: true do
      click_on '+'

      expect(page).to have_content('Rating: 1')
    end

    scenario 'can dislike foreign question', js: true do
      click_on '-'

      expect(page).to have_content('Rating: -1')
    end

    scenario 'can change his resolution', js: true do
      click_on '+'

      expect(page).to have_content('Rating: 1')
      click_on 'Unvote'
      expect(page).to have_content('Rating: 0')
      click_on '-'

      expect(page).to have_content('Rating: -1')
    end

    scenario 'All can see rating', js: true do
      click_on '+'

      expect(page).to have_content('Rating: 1')

      sign_out
      visit question_path(foreign_question)

      expect(page).to have_content('Rating: 1')
    end
  end

  scenario 'can not vote for his question' do
    visit question_path(own_question)

    expect(page).to_not have_link('+')
  end

  scenario 'Non-authenticated user can not vote' do
    visit question_path(own_question)

    expect(page).to_not have_link('+')
  end

end