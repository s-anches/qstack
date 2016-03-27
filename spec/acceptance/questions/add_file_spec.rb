require_relative '../../acceptance_helper'

feature 'Add files to question', %q{
  In order to add more information
  As an author of question
  I want to be able to attach files
} do

  given(:user) { create :user }

  background do
    sign_in(user)
    visit new_question_path
  end

  scenario 'User adds file when ask question' do
    fill_in 'Title', with: 'New question'
    fill_in 'Body', with: 'New body of question'
    attach_file 'File', "#{Rails.root}/spec/rails_helper.rb"
    click_on 'Save'

    expect(page).to have_link 'rails_helper.rb', href: '/uploads/attachment/file/1/rails_helper.rb'
  end

end