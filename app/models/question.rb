class Question < ActiveRecord::Base
  include Votable
  include Attachable

  belongs_to :user
  has_many :answers, dependent: :destroy

  validates :user_id, :title, :body, presence: true
end
