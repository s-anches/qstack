class Answer < ActiveRecord::Base
  belongs_to :user
  belongs_to :question
  has_many :attachments, as: :attachable, dependent: :destroy

  validates :user_id, :question_id, :body, presence: true

  accepts_nested_attributes_for :attachments

  default_scope -> { order(best: :desc) }

  def set_best
    ActiveRecord::Base.transaction do
      self.question.answers.update_all(best: false)
      self.update!(best: true)
    end
  end
end
