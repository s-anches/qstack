class NotificationsMailer < ApplicationMailer
  def new_answer(question, answer)
    @question_author = question.user
    @answer_author = answer.user
    @question = question
    @answer = answer
    mail(to: @question_author.email, subject: "New answer for you question #{@question.title}!")
  end
end
