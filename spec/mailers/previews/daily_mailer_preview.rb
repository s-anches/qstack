class DailyMailerPreview < ActionMailer::Preview

  def digest
    user = User.first
    questions = Question.all
    DailyMailer.digest(user, questions)
  end

end
