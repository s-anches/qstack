class User < ActiveRecord::Base
  has_many :questions, dependent: :destroy
  has_many :answers, dependent: :destroy
  has_many :votes, dependent: :destroy

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  def author_of?(object)
    id == object.user_id
  end

  def is_liked?(object)
    votes.where(votable: object).where('value > ?', 0).exists?
  end
end
