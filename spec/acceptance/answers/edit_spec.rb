require_relative '../../acceptance_helper'

feature 'Answer editing', %q{
  In order to be able to edit answer
  As an author of answer
  I want to be able to edit my answer
} do

  given(:user) { create :user }
  given(:own_answer) { create(:answer, user: user) }
  given(:foreign_answer) { create(:answer) }

  describe 'Authenticated user' do
    before { sign_in user }

    scenario 'try to edit his answer', js: true do
      visit question_path(own_answer.question)

      within "#answer-#{own_answer.id} .actions" do
        click_on 'Edit'
        fill_in 'Answer', with: 'new answer body'
        click_on 'Save'

        expect(page).to_not have_selector 'textarea'
      end
      expect(page).to_not have_content own_answer.body
      expect(page).to have_content 'new answer body'
    end

    scenario 'try to edit foreign answer' do
      visit question_path(foreign_answer.question)

      expect(page).to_not have_link 'Edit'
    end
  end

  scenario 'Non-authenticated user try to edit answer' do
    visit question_path(own_answer.question)

    expect(page).to_not have_link 'Edit'
  end
end