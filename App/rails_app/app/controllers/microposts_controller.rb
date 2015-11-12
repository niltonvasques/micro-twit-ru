class MicropostsController < ApplicationController
  before_filter :signed_in_user 
  before_filter :correct_user, only: :destroy
  before_filter :admin_user, only: [:allow, :deny]

  def create
    @micropost = current_user.microposts.build(micropost_params)
    if @micropost.save
      flash[:success] = "Micropost created!"
      redirect_to root_path
    else
      @feed_items = []
      render 'static_pages/home' 
    end
  end

  def destroy
    @micropost.destroy
    redirect_back_or root_path
  end

  def micropost_params
    params.require(:micropost).permit(:content)
  end

  def allow 
    Micropost.find(params[:id]).allow
    flash[:success] = "Post ativado."
    redirect_to admin_path
  end

  def deny 
    Micropost.find(params[:id]).deny
    flash[:success] = "Post inativado."
    redirect_to admin_path
  end

  private

    def correct_user
      @micropost = current_user.microposts.find_by_id(params[:id])
      redirect_to root_path if @micropost.nil?
    end

    def admin_user
      redirect_to(root_path) unless current_user.admin?
    end

end
