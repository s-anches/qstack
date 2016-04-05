class Vote < ActiveRecord::Base
  belongs_to :user
  belongs_to :votable, polymorphic: true

  scope :likes, -> { where("value > 0") }
  scope :dislikes, -> { where("value < 0") }
end
