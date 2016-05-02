module Voted
  extend ActiveSupport::Concern

  included do
    before_action :find_vote, only: [:like, :dislike, :unvote]
  end

  def like
    authorize @vote_object, :can_vote?
    vote(1)
  end

  def dislike
    authorize @vote_object, :can_vote?
    vote(-1)
  end

  def unvote
    authorize @vote_object
    if @vote_object.unvote(current_user)
      render json: { rating: @vote_object.rating, object: @vote_object.id }
    end
  end

  private
    def find_vote
      @vote_object = controller_name.classify.constantize.find(params[:id])
    end

    def vote(value)
      if current_user.author_of?(@vote_object)
        render json: { errors: 'Access forbidden' }, status: :forbidden
      else
        @vote_object.vote(current_user, value)
        render json: { object: @vote_object.id, rating: @vote_object.rating }
      end
    end
end
