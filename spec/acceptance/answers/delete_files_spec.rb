require_relative '../../acceptance_helper'

feature 'Delete files from answer', %q{
  In order to delete files
  As an author of answer
  I want to be able to delete files
} do

  given(:user) { create :user }
  given(:answer) { create :answer, user: user }
  given!(:attachment) { create :attachment, attachable: answer }

  given(:foreign_answer) { create :answer }
  given!(:foreign_attachment) { create :attachment, attachable: foreign_answer }

  background do
    sign_in(user)
  end

  scenario 'Author can delete files from his answer', js: true do
    visit question_path(answer.question)
    click_on 'Edit'
    check("remove-attachment-#{attachment.id}")
    click_on 'Save'

    expect(page).to_not have_link 'Gemfile'
  end

  scenario 'User can not delete files from foreign author answer' do
    visit question_path(foreign_answer.question)

    expect(page).to_not have_link 'Edit'
  end

end