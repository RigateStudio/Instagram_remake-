class PostsController < ApplicationController
  before_action :set_post, only: [:show, :update, :destroy]
  before_action :authenticate_user!, only: [:create, :update, :destroy]
  before_action :autenticate_author!, only: [:update, :destroy]
  # GET /posts
  def index
    @posts = Post.all
    @result = []
    @posts.each do |post|
      post_parameters = {id: post.id, description: post.description, user: post.user.email, created_at:post.created_at}
      post_parameters[:url] = url_for(post.image) if post.image.attached?
      @result.push(post_parameters)
    end
    render json: @result
  end


  # GET /posts/1
  def show
    render json: {post:@post, attached?: @post.image.attached?, url: url_for(@post.image)}
  end

  # POST /posts
  def create
    @post = Post.new(description: params[:post][:description], user_id: current_user.id)
    if @post.save
      render json: @post, status: :created, location: @post
    else
      render json: @post.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /posts/1
  def update
    
    if @post.update(post_params)
      render json: {post:@post, attached?: @post.image.attached?}
    else
      render json: @post.errors, status: :unprocessable_entity
    end
  end

  # DELETE /posts/1
  def destroy
    @post.destroy
  end

  private
    def autenticate_author!
      if current_user.id != set_post.user_id
        render json: {error: "Wrong current user."}, status:403
        return false
      end
      return true
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def post_params
      params.require(:post).permit(:description,:user)
    end
end
