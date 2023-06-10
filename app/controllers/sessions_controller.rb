class SessionsController < ApplicationController
  def new
  end

  #POST Login
  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      forwarding_url = session[:forwarding_url]
      reset_session
      params[:session][:remember_me] == '1' ? remember(user) : forget(user)
      login user
      redirect_to forwarding_url || user
    else
      flash.now[:danger] = "ユーザーのメールアドレスが見つかりませんでした"
      render 'new'
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url, status: :see_other
    #rootに行く時はわかりやすく、root_urlにする
  end
end
