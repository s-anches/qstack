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
  end

  scenario 'User adds files when write answers', js: true do
    fill_in 'Your answer', with: 'This is new answer'
    click_on 'Add more'
    all("input[type='file']").first.set("#{Rails.root}/config.ru")
    all("input[type='file']").last.set("#{Rails.root}/Gemfile")
    click_on 'Save answer'

    within '.answers' do
      expect(page).to have_link 'config.ru', href: '/uploads/attachment/file/1/config.ru'
      expect(page).to have_link 'Gemfile', href: '/uploads/attachment/file/2/Gemfile'
    end
  end

end