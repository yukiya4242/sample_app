class SessionsController < ApplicationController
  def new
  end

  #POST Login
  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
    else
      flash.now[:danger] = "ユーザーのメールアドレスが見つかりませんでした"
      render 'new'
    end
  end
end
