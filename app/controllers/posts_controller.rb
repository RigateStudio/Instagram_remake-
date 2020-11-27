class PostsController < ApplicationController
  before_action :set_post, only: [:show, :update, :destroy]
  before_action :authenticate_user!, only: [:create]

  # GET /posts
  def index
    @posts = Post.all
    @result = []
    @posts.each do |post|
       @result.push({id: post.id, description: post.description, url: url_for(post.image), user: post.user.email, created_at:post.created_at})
    end
    render json: @result
  end

  # GET /posts/1
  def show
    render json: {post:@post, attached?: @post.image.attached?, url: url_for(@post.image)}
  end

  # POST /posts
  def create
    @post = Post.new(description: params[:description], user_id: User.last.id)
    if @post.save
      render json: @post, status: :created, location: @post
    else
      render json: @post.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /posts/1
  def update
    if autenticate_author(@post)
      if @post.update(post_params)
        render json: {post:@post, attached?: @post.image.attached?}
      else
        render json: @post.errors, status: :unprocessable_entity
      end
    else
      render json: {error: "Wrong current user."}
    end
  end

  # DELETE /posts/1
  def destroy
    @post.destroy
  end

  private
    def autenticate_author(post)
      current_user === User.find(post.user_id)
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def post_params
      params.require(:post).permit(:description)
    end
end
