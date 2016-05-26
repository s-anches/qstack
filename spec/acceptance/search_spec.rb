require_relative '../acceptance_helper'

feature 'Full text search', %q{
  In order to be able search any information
  As an user or guest
  I want to be able to search information
} do

  given!(:user) { create(:user) }
  given!(:question) { create(:question, title: 'Searchable question', user: user) }
  given!(:answer) { create(:answer, body: 'Searchable answer', question: question) }
  given!(:comment) { create(:comment, body: 'Searchable comment', commentable: answer) }

  given!(:question_unsearchable) { create(:question, title: 'Test question') }
  given!(:answer_unsearchable) { create(:question, body: 'Test answer') }
  given!(:comment_unsearchable) { create(:question, body: 'Test comment') }

  background do
    index
    visit search_path
  end

  scenario 'User can find correct object', js: true do
    fill_in "Query", with: "Searchable"
    select "All", from: "Scope"

    click_on 'Find...'

    expect(page).to have_content("Question \"#{question.title}\"")
    expect(page).to have_content("Answer for \"#{question.title}\"")
    expect(page).to have_content(answer.body)
    expect(page).to have_content("Comment for answer \"#{question.title}\"")
    
    expect(page).to_not have_content(question_unsearchable.title)
    expect(page).to_not have_content(answer_unsearchable.body)
    expect(page).to_not have_content(comment_unsearchable.body)
  end

end