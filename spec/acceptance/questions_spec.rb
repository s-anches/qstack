require 'rails_helper'

feature 'User can view all question', %q{
  In order to be view all question
  As an user
  I want to go to index page
} do

  given(:questions) { create_list(:question, 5) }
  before { questions }

  scenario 'view all questions' do
    visit root_path

    questions.each do |question|
      expect(page).to have_content question.title
      expect(page).to have_content question.body
    end
  end

end

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

feature 'User can see question with answers', %q{
  In order to be able see question with answers
  As an user
  I want to be able go to question page
} do

  given(:question) { create(:question) }
  given(:answers) { create_list(:answer, 5, question: question) }

  before do
    question
    answers
  end

  scenario 'see question with answers' do
    visit root_path
    click_on question.title

    expect(page).to have_content question.title
    expect(page).to have_content question.body
    answers.each do |answer|
      expect(page).to have_content answer.body
    end
  end

end

feature 'User can delete only his question', %q{
  In order to be able delete my question
  As an author of question
  I want to be able delete question
} do

  given(:user) { create :user }
  given(:question) { create(:question, user: user) }
  given(:other_question) { create(:question) }

  scenario 'can delete his question' do
    sign_in(user)
    visit question_path(question)
    click_on 'Delete'

    expect(page).to have_content 'Question successfuly deleted.'
    expect(current_path).to eq questions_path
  end

  scenario 'can not delete other owner question' do
    sign_in(user)
    visit question_path(other_question)
    click_on 'Delete'

    expect(page).to have_content 'You can not delete not his question.'
  end

end