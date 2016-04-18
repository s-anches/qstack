class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_commentable, only: [:create]
  before_action :load_comment, only: [:destroy]

  def create
    @comment = @commentable.comments.build(comment_params.merge({ user: current_user }))
    respond_to do |format|
      if @comment.save
        format.js do
          PrivatePub.publish_to "/#{@comment.commentable_type.pluralize.downcase}/#{@comment.commentable_id}/comments",
            comment: @comment.to_json
        end
      else
        format.js
      end
    end
  end

  def destroy
    @comment.destroy if current_user.author_of?(@comment)
    # respond_to do |format|
    #   format.js do
    #     commentable_type = @comment.commentable_type.pluralize.downcase
    #     commentable_id = @comment.commentable_id
    #     @comment.destroy if current_user.author_of?(@comment)
    #     PrivatePub.publish_to "/#{commentable_type}/#{commentable_id}/comments",
    #       comment: @comment.to_json
    #   end
    # end
  end

  private
    def load_commentable
      commentable_id = params.keys.detect { |k| k.to_s =~ /(question|answer)_id/ } 
      klass = $1.classify.constantize
      @commentable = klass.find(params[commentable_id])
    end

    def comment_params
      params.require(:comment).permit(:body)
    end

    def load_comment
      @comment = Comment.find(params[:id])
    end
end
