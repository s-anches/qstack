FactoryGirl.define do
  sequence(:answer_body) { |n| "Example body #{n}" }

  factory :answer do
    user
    question
    body :answer_body
  end

  factory :invalid_answer, class: "Answer" do
    user
    question
    body nil
  end
end
