require_relative '../../acceptance_helper'

feature 'User can delete only his question', %q{
  In order to be able delete my question
  As an author of question
  I want to be able delete question
} do

  given(:user) { create :user }
  given(:question) { create(:question, user: user) }
  given(:other_question) { create(:question) }

  scenario 'can delete his question' do
    sign_in(user)
    visit question_path(question)
    click_on 'Delete'

    expect(page).to have_content 'Question successfuly deleted.'
    expect(page).to_not have_content question.title
    expect(current_path).to eq questions_path
  end

  scenario 'can not delete other owner question' do
    sign_in(user)
    visit question_path(other_question)

    expect(page).to_not have_link 'Delete'
  end

end