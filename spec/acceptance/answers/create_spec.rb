require 'rails_helper'

feature 'User can create answer', %q{
  In order to be able write answer to question
  As an authenticated user
  I want to be able to write answer
} do

  given(:user) { create :user }
  given!(:question) { create :question }

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