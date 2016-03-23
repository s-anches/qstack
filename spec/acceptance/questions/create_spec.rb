require 'rails_helper'

feature 'Create new question', %q{
  In order to be able to ask question
  As an authenticated user
  I want to be able to ask question
} do

  given(:user) { create :user }

  scenario 'Authenticated user create question with valid attributes' do
    sign_in(user)

    visit questions_path
    click_on 'New question'
    fill_in 'Title', with: 'New question'
    fill_in 'Body', with: 'New body of question'
    click_on 'Save'

    expect(page).to have_content 'New question'
    expect(page).to have_content 'New body of question'
  end

  scenario 'Authenticated user create question witn invalid attributes' do
    sign_in(user)

    visit questions_path
    click_on 'New question'
    click_on 'Save'

    expect(page).to have_content 'INVALID ATTRIBUTES'
  end

  scenario 'Non-authenticated user try to create question' do
    visit questions_path
    click_on 'New question'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end

end