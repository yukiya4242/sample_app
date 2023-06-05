class SessionsController < ApplicationController
  def new
  end

  #POST Login
  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      login user
      redirect_to user
    else
      flash.now[:danger] = "ユーザーのメールアドレスが見つかりませんでした"
      render 'new'
    end
  end

  def destroy
    log_out
    redirect_to root_url, status: :see_other
    #rootに行く時はわかりやすく、root_urlにする
  end
end
