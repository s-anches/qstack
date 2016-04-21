class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_commentable, only: [:create]
  before_action :load_comment, only: [:destroy]
  after_action :publish_to

  respond_to :js

  def create
    @comment = @commentable.comments.create(comment_params.merge({ user: current_user }))
    respond_with(@comment)
  end

  def destroy
    @comment.destroy if current_user.author_of?(@comment)
  end

  private
    def load_commentable
      commentable_id = params.keys.detect { |k| k.to_s =~ /(question|answer)_id/ }
      klass = $1.classify.constantize
      @commentable = klass.find(params[commentable_id])
    end

    def load_comment
      @comment = Comment.find(params[:id])
    end

    def publish_to
      PrivatePub.publish_to(
        channel, comment: @comment.to_json, action: self.action_name
      ) if @comment.errors.empty?
    end

    def channel
      "/questions/#{@commentable.try(:question).try(:id) || @commentable.id}/comments"
    end

    def comment_params
      params.require(:comment).permit(:body)
    end
end
