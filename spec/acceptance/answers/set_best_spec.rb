require_relative '../../acceptance_helper'

feature 'Author can set best answer', %q{
  In order to be able set best answer
  As an author of question
  I want to be able to set best answer
} do

  given(:user) { create :user }
  given(:question) { create(:question, user: user) }
  given!(:answer_one) { create(:answer, question: question) }
  given!(:answer_two) { create(:answer, question: question, best: true) }
  given(:answer) { create(:answer) }

  describe 'Authenticated user' do
    before { sign_in(user) }

    scenario 'try to set best answer for his question', js: true do
      visit question_path(question)
      within "#answer-#{answer_one.id}" do
        click_on 'Set best'

        expect(page).to have_content 'Best'
      end
    end

    scenario 'try to change best answer for his question', js: true do
      visit question_path(question)

      within "#answer-#{answer_two.id}" do
        expect(page).to have_content 'Best'
      end
      within "#answer-#{answer_one.id}" do
        click_on 'Set best'

        expect(page).to have_content 'Best'
      end
      within "#answer-#{answer_two.id}" do
        expect(page).to_not have_content 'Best'
      end
    end

    scenario 'try to set best answer for foreign question' do
      visit question_path(answer.question)

      expect(page).to_not have_link 'Set best'
    end
  end

  scenario 'Non-authenticated user try to set best answer' do
    visit question_path(question)

    expect(page).to_not have_link 'Set best'
  end

end