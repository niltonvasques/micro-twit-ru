class MicropostsController < ApplicationController
  before_filter :signed_in_user 
  before_filter :correct_user, only: :destroy

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

  def destroy
    @micropost.destroy
    redirect_back_or root_path
  end

  def micropost_params
    params.require(:micropost).permit(:content)
  end

  private

    def correct_user
      @micropost = current_user.microposts.find_by_id(params[:id])
      redirect_to root_path if @micropost.nil?
    end

end
