require_relative '../../acceptance_helper'

feature 'User can vote for answer', %q{
  In order to be able up/down rating of answer
  As an authenticated user
  I want to vote for answer
} do

  given(:user) { create(:user) }
  given(:user_two) { create(:user) }
  given(:own_answer) { create(:answer, user: user) }
  given(:foreign_answer) { create(:answer) }

  describe 'Authenticated user' do

    before do
      sign_in(user)
      visit question_path(foreign_answer.question)
    end

    scenario 'can like foreign answer', js: true do
      within '.answers' do
        click_on '+'

        expect(page).to have_content('Rating: 1')
      end
    end

    scenario 'can dislike foreign answer', js: true do
      within '.answers' do
        click_on '-'

        expect(page).to have_content('Rating: -1')
      end
    end

    scenario 'can change his resolution', js: true do
      within '.answers' do
        click_on '+'

        expect(page).to have_content('Rating: 1')
        click_on 'Unvote'
        expect(page).to have_content('Rating: 0')
        click_on '-'

        expect(page).to have_content('Rating: -1')
      end
    end

    scenario 'All can see rating', js: true do
      within '.answers' do
        click_on '+'

        expect(page).to have_content('Rating: 1')
      end

      sign_out
      visit question_path(foreign_answer.question)

      within '.answers' do
        expect(page).to have_content('Rating: 1')
      end
    end
  end

  scenario 'can not vote for his answer' do
    visit question_path(own_answer.question)

    within '.answers' do
      expect(page).to_not have_link('+')
    end
  end

  scenario 'Non-authenticated user can not vote' do
    visit question_path(own_answer.question)

    within '.answers' do
      expect(page).to_not have_link('+')
    end
  end

end