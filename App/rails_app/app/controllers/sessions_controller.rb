class SessionsController < ApplicationController
  before_filter :signed, only: [:new, :create]

  def new
  end

  def create
    user = User.find_by_email(params[:session][:email])
    if user && user.authenticate(params[:session][:password])
      sign_in user
      if user.admin?
        redirect_back_or admin_path 
      else
        redirect_back_or root_path 
      end
    else
      flash.now[:error] = 'Combinação inválida de email/senha' # Not quite right!
      render 'new'
    end
  end

  def destroy
    sign_out
    redirect_to root_path
  end

  private

    def signed
      if signed_in?
        if current_user.admin?
          redirect_to admin_path, notice: "Você já está logado." 
        else
          redirect_to root_path, notice: "Você já está logado." 
        end
      end
    end
end
