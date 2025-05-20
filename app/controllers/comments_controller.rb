class CommentsController < ApplicationController
    before_action :set_comment, only: [:update, :destroy]
  before_action :check_owner, only: [:update, :destroy]

  def create
    post = Post.find(params[:post_id])
    comment = post.comments.build(comment_params.merge(user_id: @current_user.id))
    if comment.save
      render json: comment.as_json(include: { user: { only: [:id, :name] } }), status: :created
    else
      render json: { errors: comment.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @comment.update(comment_params)
      render json: @comment.as_json(include: { user: { only: [:id, :name] } })
    else
      render json: { errors: @comment.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @comment.destroy
    render json: { message: 'Comment deleted' }
  end

  private

  def set_comment
    @comment = Comment.find(params[:id])
  end

  def check_owner
    unless @comment.user_id == @current_user.id
      render json: { error: 'Unauthorized' }, status: :unauthorized
    end
  end

  def comment_params
    params.permit(:body)
  end
end
  