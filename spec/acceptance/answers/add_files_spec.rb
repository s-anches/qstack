require_relative '../../acceptance_helper'

feature 'Add files to answer', %q{
  In order to add more information
  As an author of answer
  I want to be able to attach files
} do

  given(:user) { create :user }
  given(:question) { create :question }

  background do
    sign_in(user)
    visit question_path(question)
    click_on 'New answer'
  end

  scenario 'User adds files when write answers', js: true do
    fill_in 'Your answer', with: 'This is new answer'
    click_on 'Add file'

    all("input[type='file']", visible: false).first.set("#{Rails.root}/config.ru")
    all("input[type='file']", visible: false).last.set("#{Rails.root}/Gemfile")
    click_on 'Save'

    within '.answers' do
      expect(page).to have_link 'config.ru', href: '/uploads/attachment/file/1/config.ru'
      expect(page).to have_link 'Gemfile', href: '/uploads/attachment/file/2/Gemfile'
    end
  end

end