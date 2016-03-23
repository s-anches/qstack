FactoryGirl.define do
  sequence(:title) { |n| "Example title #{n}" }
  sequence(:body) { |n| "Example body #{n}" }

  factory :question do
    user
    title
    body
  end

  factory :invalid_question, class: "Question" do
    user
    title nil
    body nil
  end
end
