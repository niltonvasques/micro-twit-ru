module SessionsHelper

  def sign_in(user)
    cookies.permanent[:remember_token] = user.remember_token
    self.current_user = user
  end

  def sign_out
    self.current_user = nil
    cookies.delete(:remember_token)
  end

  def signed_in?
    !current_user.nil?
  end

  def current_user=(user)
    @current_user = user
  end

  def current_user
    # Was need use this check on cookies, 
    # because find by token are return the user with nil params
    if !@current_user && cookies[:remember_token]
      @current_user = User.find_by_remember_token(cookies[:remember_token])
    else
      @current_user
    end
  end

  def current_user?(user)
    user == current_user
  end
  
  def signed_in_user
    unless signed_in? 
      store_location
      redirect_to signin_path, notice: "Please sign in."
    end
  end

  def redirect_back_or(default)
    redirect_to(session[:return_to] || default)
    session.delete(:return_to)
  end

  def store_location
    session[:return_to] = request.fullpath
  end

end
