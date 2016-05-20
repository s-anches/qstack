class Question < ActiveRecord::Base
  include Votable
  include Attachable
  include Commentable

  belongs_to :user
  has_many :answers, dependent: :destroy

  has_many :subscriptions, dependent: :destroy
  has_many :users, through: :subscriptions, dependent: :destroy

  validates :user_id, :title, :body, presence: true

  scope :digest, -> { where("created_at >= ?", 1.day.ago) }

  after_create :subscribe

  private
    def subscribe
      user.subscribe(self)
    end
end
