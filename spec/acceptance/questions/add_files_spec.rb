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

  scenario 'User adds files when ask question', js: true do
    fill_in 'Title', with: 'New question'
    fill_in 'Body', with: 'New body of question'
    click_on 'Add file'
    click_on 'Add file'

    all("input[type='file']", visible: false).first.set("#{Rails.root}/config.ru")
    all("input[type='file']", visible: false).last.set("#{Rails.root}/Gemfile")
    click_on 'Save'

    expect(page).to have_link 'config.ru', href: '/uploads/attachment/file/1/config.ru'
    expect(page).to have_link 'Gemfile', href: '/uploads/attachment/file/2/Gemfile'
  end

end