module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, as: :votable, dependent: :destroy
  end

  def vote(user, value)
    vote = votes.find_or_initialize_by(user: user)
    vote.update(value: value)
  end

  def unvote(user)
    vote = votes.find_by(user: user)
    vote.destroy if vote
  end

  def rating
    votes.sum(:value)
  end

end