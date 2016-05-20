class QuestionSubscribersJob < ActiveJob::Base
  queue_as :default

  def perform(question, answer)
    question.subscriptions.find_each do |subscriber|
      NotificationsMailer.new_answer(subscriber.user, question, answer).deliver_later
    end
  end
end
