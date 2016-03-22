require 'rails_helper'

feature 'User can write answer', %q{
  In order to be able write answer to question
  As an authenticated user
  I want to be able to write answer
} do

  given(:user) { create :user }
  given(:question) { create :question }
  before { question }

  scenario 'Authenticated user with valid attributes' do
    sign_in(user)
    visit question_path(question)

    fill_in 'Body', with: 'This is new answer'
    click_on 'Save answer'

    expect(current_path).to eq question_path(question)
    expect(page).to have_content('This is new answer')
  end

  scenario 'Authenticated user with invalid attributes' do
    sign_in(user)
    visit question_path(question)
    click_on 'Save answer'

    expect(current_path).to eq question_path(question)
    expect(page).to have_content('Invalid answer')
  end

  scenario 'Non-authenticated user try to create answer' do
    visit question_path(question)
    fill_in 'Body', with: 'This is new answer'
    click_on 'Save answer'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end

end

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
    find(".delete-answer-link").click

    expect(page).to have_content 'Answer succefully deleted'
    expect(page).to_not have_content answer.body
  end

  scenario 'can not delete other owner question' do
    sign_in(user)
    visit question_path(other_answer.question)
    expect(page).to_not have_css '.delete-answer-link'
  end

end