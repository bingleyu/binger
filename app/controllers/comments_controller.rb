class CommentsController < ApplicationController
  before_action :signed_in_user, only: [:create, :destroy]
  
  def new
    @comment=Comment.new
  end
 
  def create
  	@micropost = Micropost.find(params[:micropost_id])
    @comment = Comment.new(comment_params)
    @comment.micropost = @micropost
    @comment.user = current_user

      respond_to do |format|
        @comment.save
        @comments = @micropost.comments
        format.html { redirect_to micropost_path(@micropost)  }
        format.js {}
      end
  end

  def destroy
  	@comment=Comment.find_by(id: params[:id])
    @micropost = @comment.micropost

      respond_to do |format|
        if @comment.present?
          @comment.destroy
          format.html {redirect_to :back }
          format.js {}
        else
          flash[:notice] = "Comment failed to delete."
          format.html { redirect_to :back }
        end
      end
  end    

  private

    def comment_params
      params.require(:comment).permit(:comment_content)
    end
    
end