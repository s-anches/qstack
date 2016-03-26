require_relative '../../acceptance_helper'

feature 'User can delete only his answer', %q{
  In order to be able delete my answer
  As an author of answer
  I want to be able delete answer
} do

  given(:user) { create :user }
  given(:own_answer) { create(:answer, user: user) }
  given(:foreign_answer) { create(:answer) }

  describe 'Authenticated user' do
    scenario 'try to delete his answer', js: true do
      sign_in(user)
      visit question_path(own_answer.question)

      within '.answers .answer .actions' do
        click_on 'Delete'
      end

      expect(page).to_not have_content own_answer.body
    end

    scenario 'try to delete foreign answer' do
      sign_in(user)
      visit question_path(foreign_answer.question)

      expect(page).to_not have_link 'Delete'
    end
  end

  scenario 'Non-authenticated user try to delete answer' do
    visit question_path(own_answer.question)

    expect(page).to_not have_link 'Delete'
  end

end