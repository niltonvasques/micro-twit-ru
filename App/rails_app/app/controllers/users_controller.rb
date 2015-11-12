class UsersController < ApplicationController
  before_filter :signed_in_user, 
    only: [:index, :edit, :update, :destroy, :following, :followers, :allow, :deny]
  before_filter :correct_user, only: [:edit, :update]
  before_filter :admin_user, only: [:destroy, :index, :allow, :deny]
  before_filter :block_signed_create, only: [:new, :create]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      sign_in @user
      flash[:success] = "Bem vindo ao Colé de Merma do RU!"
      redirect_to root_path
    else
      render 'new' end
  end

  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.page(params[:page])
  end

  def index
    @users = User.page(params[:page])
    @microposts = Micropost.all.page(params[:page])
  end

  def edit
  end

  def update
    if @user.update_attributes(user_params)
      flash[:success] = "Perfil atualizado."
      sign_in @user
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User destroyed"
    redirect_to users_path
  end

  def following 
    @title  = "Following"
    @user   = User.find(params[:id])
    @users  = @user.followed_users.page(params[:page])
    render 'show_follow'
  end

  def followers
    @title = "Followers"
    @user   = User.find(params[:id])
    @users  = @user.followers.page(params[:page])
    render 'show_follow'
  end

  def allow 
    User.find(params[:id]).allow
    flash[:success] = "Usuário ativado"
    redirect_to users_path
  end

  def deny 
    user = User.find(params[:id])
    unless user.admin?
      user.deny
      flash[:success] = "Usuário inativado."
    else
      flash[:error] = "Não é possível desativar um administrador."
    end
    redirect_to users_path
  end

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  private

    def block_signed_create
      redirect_to root_path if signed_in?
    end

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path)  unless current_user?(@user)
    end

    def admin_user
      redirect_to(root_path) unless current_user.admin?
    end

end
