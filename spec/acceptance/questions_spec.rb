require 'rails_helper'

feature 'Create new question', %q{
  In order to be able to ask question
  As an user
  I want to be able to ask question
} do

  scenario 'with valid attributes' do
    visit root_path
    click_on 'New question'

    fill_in 'Title', with: 'New question'
    fill_in 'Body', with: 'New body of question'
    click_on 'Save'

    expect(page).to have_content 'New question'
    expect(page).to have_content 'New body of question'
  end

  scenario 'witn invalid attributes' do
    visit root_path
    click_on 'New question'
    click_on 'Save'

    expect(page).to have_content 'INVALID ATTRIBUTES'
  end

end

