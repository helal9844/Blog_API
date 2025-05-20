class PostsController < ApplicationController
    before_action :set_post, only: [:show, :update, :destroy]
  before_action :check_owner, only: [:update, :destroy]

  def index
    posts = Post.includes(:tags, :comments).all
    render json: posts.as_json(include: { tags: { only: :name }, comments: { include: { user: { only: [:id, :name] } }, except: [:user_id, :post_id] } })
  end

  def show
    render json: @post.as_json(include: { tags: { only: :name }, comments: { include: { user: { only: [:id, :name] } }, except: [:user_id, :post_id] } })
  end

  def create
    if params[:tags].blank? || !params[:tags].any?
      return render json: { errors: ['Post must have at least one tag'] }, status: :unprocessable_entity
    end
  
    post = @current_user.posts.build(post_params)
    post.tags = params[:tags].map { |name| Tag.find_or_create_by(name: name) }
  
    if post.save
      render json: post.as_json(include: :tags), status: :created
    else
      render json: { errors: post.errors.full_messages }, status: :unprocessable_entity
    end
  end
  

  def update
    if params[:tags]
      @post.tags = params[:tags].map { |name| Tag.find_or_create_by(name: name) }
    end
    if @post.update(post_params)
      render json: @post.as_json(include: :tags)
    else
      render json: { errors: @post.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @post.destroy
    render json: { message: 'Post deleted' }
  end

  private

  def set_post
    @post = Post.find(params[:id])
  end

  def check_owner
    unless @post.user_id == @current_user.id
      render json: { error: 'Unauthorized' }, status: :unauthorized
    end
  end

  def post_params
    params.permit(:title, :body)
  end
end
  