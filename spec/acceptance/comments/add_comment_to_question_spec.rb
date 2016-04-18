require_relative '../../acceptance_helper'

feature 'User comment', %q{
  In order to be able write comments to question
  As an authenticated user
  I want to be able to write comment
} do

  given!(:user) { create :user }
  given!(:question) { create :question }

  scenario 'Authenticated user try to create comment', js: true do
    sign_in(user)
    visit question_path(question)
    click_on 'Add comment'

    fill_in 'Body', with: 'This is new comment'
    click_on 'Save'

    expect(current_path).to eq question_path(question)
    within '.comments' do
      expect(page).to have_content 'This is new comment'
    end
  end

  scenario 'Authenticated user try to create invalid comment', js: true do
    sign_in(user)
    visit question_path(question)
    click_on 'Add comment'
    click_on 'Save'

    expect(current_path).to eq question_path(question)
    expect(page).to have_content("Body can't be blank")
  end

  scenario 'Non-authenticated user try to create answer' do
    visit question_path(question)

    expect(page).to_not have_link 'Add comment'
  end

end