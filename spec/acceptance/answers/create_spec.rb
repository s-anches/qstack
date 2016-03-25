require_relative '../../acceptance_helper'

feature 'User answer', %q{
  In order to be able write answer to question
  As an authenticated user
  I want to be able to write answer
} do

  given!(:user) { create :user }
  given!(:question) { create :question }

  scenario 'Authenticated user try to create answer', js: true do
    sign_in(user)
    visit question_path(question)

    fill_in 'Your answer', with: 'This is new answer'
    click_on 'Save answer'

    expect(current_path).to eq question_path(question)
    within '.answers' do
      expect(page).to have_content 'This is new answer'
    end
  end

  scenario 'Authenticated user try to create invalid answer', js: true do
    sign_in(user)
    visit question_path(question)
    click_on 'Save answer'

    expect(current_path).to eq question_path(question)
    expect(page).to have_content("Body can't be blank")
  end

  scenario 'Non-authenticated user try to create answer' do
    visit question_path(question)

    expect(page).to_not have_content 'Your answer'
  end

end