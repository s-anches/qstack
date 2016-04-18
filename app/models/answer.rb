class Answer < ActiveRecord::Base
  include Votable
  include Attachable
  include Commentable

  belongs_to :user
  belongs_to :question

  validates :user_id, :question_id, :body, presence: true

  default_scope -> { order(best: :desc) }

  def set_best
    ActiveRecord::Base.transaction do
      self.question.answers.update_all(best: false)
      self.update!(best: true)
    end
  end
end
