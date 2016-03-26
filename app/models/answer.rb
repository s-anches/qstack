class Answer < ActiveRecord::Base
  belongs_to :user
  belongs_to :question

  validates :user_id, :question_id, :body, presence: true

  default_scope -> { order(best: :desc) }

  def set_best
    ActiveRecord::Base.transaction do
      self.question.answers.update_all(best: false)
      raise ActiveRecord::Rollback unless self.update(best: true)
    end
  end
end
