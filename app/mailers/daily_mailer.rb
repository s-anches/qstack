class DailyMailer < ApplicationMailer
  def digest(user)
    @user = user
    @questions = Question.digest
    mail(to: @user.email, subject: 'Every day digest!') if @questions.presence
  end
end
