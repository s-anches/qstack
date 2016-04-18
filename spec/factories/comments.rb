FactoryGirl.define do
  sequence(:comment_body) { |n| "Example body #{n}" }

  factory :comment do
    user
    body :comment_body
  end

  factory :invalid_comment, class: "Comment" do
    user
    body nil
  end
end
