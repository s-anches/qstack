module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, as: :votable, dependent: :destroy
    accepts_nested_attributes_for :votes
  end

  def vote(user, value)
    vote = votes.find_or_initialize_by(user: user)
    vote.update(value: value)
  end

  def unvote(user)
    vote = votes.find_by(user: user)
    vote.destroy if vote
  end

  def is_liked?(user)
    votes.where(user: user).where('value > ?', 0).exists?
  end

  def rating
    votes.sum(:value)
  end

end