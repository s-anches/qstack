class NotificationsMailer < ApplicationMailer
  def new_answer(user, question, answer)
    @user = user
    @question = question
    @answer = answer
    
    mail(to: @user.email, subject: "New answer for you question #{@question.title}!")
  end
end
