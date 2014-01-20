class MicropostsController < ApplicationController
  before_action :signed_in_user, only: [:create, :destroy]
  before_action :correct_user,   only: :destroy

  def create
    @micropost = current_user.microposts.build(micropost_params)

    respond_to do |format|
      if @micropost.save
        @feed_items = current_user.feed.paginate(page: params[:page])
        format.html { redirect_to @micropost, notice: 'Micropost was successfully created.' }
        format.js   {}
        format.json { render json: @microposts, status: :created, location: @micropost }
      else
        @feed_items = []
        format.html { render 'static_pages/home' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @micropost = Micropost.find_by(id: params[:id])
    #current_user = @micropost.user
    
      respond_to do |format|
        if @micropost.destroy
          @feed_items = current_user.feed.paginate(page: params[:page])
          @microposts = current_user.microposts.paginate(page: params[:page])
          format.html { redirect_to :back }
          format.js {}
        else
          flash[:notice] = "Micropost failed to delete."
          format.html { redirect_to :back }
          format.js {}
        end
      end
  end
  
  def show_comment
    @micropost = Micropost.find_by(id: params[:id])
    @comments = @micropost.comments
    @comment = Comment.new

      respond_to do |format|
        format.html { render @comments }
        format.js {}
      end
  end

  private

    def micropost_params
      params.require(:micropost).permit(:content, :to)
    end
    
    def correct_user
      @micropost = current_user.microposts.find_by(id: params[:id])
      redirect_to root_url if @micropost.nil?
    end
end