class SessionsController < ApplicationController
  before_filter :signed, only: [:new, :create]

  def new
  end

  def create
    user = User.find_by_email(params[:session][:email])
    if user && user.authenticate(params[:session][:password])
      sign_in user
      redirect_back_or user
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
      redirect_to root_path, notice: "Você já está logado." if signed_in?
    end
end
