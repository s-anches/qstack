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