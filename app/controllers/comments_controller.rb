class CommentsController < ApplicationController
  before_action :set_comment, only: %i[ show edit update destroy ]
  before_action :authenticate_user!, except: [:index, :show]


  # GET /comments or /comments.json
  def index
    @comments = Comment.all
  end

  # GET /comments/1 or /comments/1.json
  def show
    @posts = Post.all.pluck :title, :id
    #@post = @comment.post
    @user = @comment.user
  end

  # GET /comments/new
  def new
    @comment = Comment.new
    @posts = Post.all.pluck :title, :id, :user_id
    @post = @comment.post
    @comment.user = current_user
    #capturo parametro del link
    #@com = params[:com]
  end

  # GET /comments/1/edit
  def edit
    @posts = Post.all.pluck :title, :id
     if current_user.id == @comment.user_id || current_user.role == "admin"
     else
      redirect_to comments_path(@comment), alert: "No tienes autorización para editar este comentario"
    end
 end

  # POST /comments or /comments.json
  def create
    @comment = Comment.new(comment_params)
    @posts = Post.all.pluck :title, :id
    #@post = @comment.post
    #@comment.user = current_user

    respond_to do |format|
      if @comment.save
        format.html { redirect_to comment_url(@comment), notice: "Comment was successfully created." }
        format.json { render :show, status: :created, location: @comment }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /comments/1 or /comments/1.json
  def update
    @posts = Post.all.pluck :title, :id
    respond_to do |format|
      if @comment.update(comment_params)
        format.html { redirect_to comment_url(@comment), notice: "Comment was successfully updated." }
        format.json { render :show, status: :ok, location: @comment }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
end

  # DELETE /comments/1 or /comments/1.json
  def destroy
    @posts = Post.all.pluck :title, :id
    @comment.destroy!
      respond_to do |format|
      format.html { redirect_to comments_path, status: :see_other, notice: "Comentario Eliminado." }
      format.json { head :no_content }
    end
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_comment
      @comment = Comment.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def comment_params
      params.require(:comment).permit(:content, :user_id, :post_id)
    end
end
