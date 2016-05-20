class NotificationsMailerPreview < ActionMailer::Preview
  def new_answer
    NotificationsMailer.new_answer(User.first, Question.first, Question.first.answers.first)
  end
end
