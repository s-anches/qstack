require_relative '../../acceptance_helper'

feature 'Delete files from question', %q{
  In order to delete files
  As an author of question
  I want to be able to delete files
} do

  given(:user) { create :user }
  given(:own_question) { create :question, user: user }
  given!(:attachment) { create :attachment, attachable: own_question }

  given(:foreign_question) { create :question }
  given!(:foreign_attachment) { create :attachment, attachable: foreign_question }

  background do
    sign_in(user)
  end

  scenario 'Author can delete files from his question', js: true do
    visit question_path(own_question)
    click_on 'Edit'
    check("remove-attachment-#{attachment.id}")
    click_on 'Save'

    expect(page).to_not have_link 'Gemfile'
  end

end