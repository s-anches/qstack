class NotificationsMailerPreview < ActionMailer::Preview
  def new_answer
    NotificationsMailer.new_answer(Question.first, Question.first.answers.first)
  end
end
