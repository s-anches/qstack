require 'rails_helper'

feature 'User can write answer', %q{
  In order to be able write answer to question
  As an user
  I want to be able to write answer
} do

  given(:question) { create :question}
  before { question }

  scenario 'with valid attributes' do
    visit question_path(question)

    fill_in 'Body', with: 'This is new answer'
    click_on 'Save answer'

    expect(current_path).to eq question_path(question)
    expect(page).to have_content('This is new answer')
  end

  scenario 'with invalid attributes' do
    visit question_path(question)
    click_on 'Save answer'

    expect(current_path).to eq question_path(question)
    expect(page).to have_content('Invalid answer')
  end

end