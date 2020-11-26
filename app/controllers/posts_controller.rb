class PostsController < ApplicationController
  before_action :set_post, only: [:show, :update, :destroy]

  # GET /posts
  def index
    @posts = Post.all

    render json: @posts
  end

  # GET /posts/1
  def show

    render json: {post:@post, attached?: @post.image.attached?}
  end

  # POST /posts
  def create
    @post = Post.new(post_params, user_id: User.last.id)
    @post.last.image.attach(io: File.open(Rails.root.join('app', 'assets', 'images', "colorcat_14.png")), filename: "colorcat_14.png", content_type: 'image/png')

    if @post.save
      render json: @post, status: :created, location: @post
    else
      render json: @post.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /posts/1
  def update
    @post.last.image.attach(io: File.open(Rails.root.join('app', 'assets', 'images', "colorcat_14.png")), filename: "colorcat_14.png", content_type: 'image/png')

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
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def post_params
      params.require(:post).permit(:description)
    end
end
