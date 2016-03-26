require_relative '../../acceptance_helper'

feature 'Question editing', %q{
  In order to be able to edit question
  As an author of question
  I want to be able to edit my question
} do

  given(:user) { create(:user) }
  given(:own_question) { create(:question, user: user) }
  given(:foreign_question) { create(:question) }

  describe 'Authenticated user' do
    before { sign_in user }

    scenario 'try to edit his question', js: true do
      visit question_path(own_question)
      click_on 'Edit'
      fill_in 'Title', with: 'Edited title'
      fill_in 'Body', with: 'Edited body'
      click_on 'Save'

      expect(page).to_not have_content own_question.title
      expect(page).to_not have_content own_question.body
      expect(page).to have_content 'Edited title'
      expect(page).to have_content 'Edited body'
      within '.question .actions' do
        expect(page).to_not have_selector 'textarea'
      end
    end
    scenario 'try to edit foreign question' do
      visit question_path(foreign_question)

      expect(page).to_not have_link 'Edit'
    end
  end

  scenario 'Non-authenticated user try to edit question' do
    visit question_path(own_question)

    expect(page).to_not have_link 'Edit'
  end
end