class MicropostsController < ApplicationController
  before_filter :signed_in_user 
  before_filter :correct_user, only: :destroy
  before_filter :admin_user, only: [:allow, :deny]

  def new
    @tweets = PreDefinedTweet.all
  end

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

  def post_tweet
    t = PreDefinedTweet.find params[:tweet_id]

    p = current_user.microposts.new
    p.content = t.content

    if p.save
      flash[:success] = "Micropost criado!"
      redirect_to root_path
    else
      flash[:error] = "Erro ao criar micropost!"
      redirect_to new_micropost_path
    end
  end

  def retweet
    t = Micropost.find params[:id]

    unless t.user == current_user
      if t.retweet(current_user)
        flash[:success] = "Micropost replicado!"
      else
        flash[:error] = "Erro ao replicar micropost!"
      end
    else
        flash[:error] = "Não é possível replicar seu próprio micropost!"
    end
    redirect_to root_path 
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
