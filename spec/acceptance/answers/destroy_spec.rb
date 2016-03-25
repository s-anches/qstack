require_relative '../../acceptance_helper'

feature 'User can delete only his answer', %q{
  In order to be able delete my answer
  As an author of answer
  I want to be able delete answer
} do

  given(:user) { create :user }
  given(:answer) { create(:answer, user: user) }
  given(:other_answer) { create(:answer) }

  scenario 'can delete his answer' do
    sign_in(user)
    visit question_path(answer.question)

    within '.answers .answer .actions' do
      click_on 'Delete'
    end

    expect(page).to have_content 'Answer succefully deleted'
    expect(page).to_not have_content answer.body
  end

  scenario 'can not delete other owner question' do
    sign_in(user)
    visit question_path(other_answer.question)

    expect(page).to_not have_link 'Delete'
  end

end