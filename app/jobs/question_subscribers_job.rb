class QuestionSubscribersJob < ActiveJob::Base
  queue_as :default

  def perform(question, answer)
    NotificationsMailer.new_answer(question, answer).deliver_later
  end
end
