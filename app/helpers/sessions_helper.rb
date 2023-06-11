module SessionsHelper

  def login(user)
    session[:user_id] = user.id
  end

  # 記憶トークンcookieに対応するユーザーを返す
  def current_user
    if (user_id = session[:user_id])
      @current_user ||= User.find_by(id: user_id)
    elsif (user_id = cookies.encrypted[:user_id])
      user = User.find_by(id: user_id)
      if user && user.authenticated?(:remember, cookies[:remember_token])
        login user
        @current_user = user
      end
    end
  end

  #current_userかどうかチェックする
  def current_user?(user)
    user && user == current_user
  end

  #ユーザーがログインしてるのか確認。
  def logged_in?
    #[!]はnotオペレーターと呼ばれる
    #current_userがnilではない(つまり存在するなら) => ture
    #current_userがnil(つまり存在しないなら) => false
    !current_user.nil?
  end

  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end

  def log_out
    forget(current_user)
    reset_session
    @current_user = nil
  end

  # 永続セッションのためにユーザーをデータベースに記憶する
  def remember(user)
    user.remember
    cookies.permanent.encrypted[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end

  def store_location
    session[:forwarding_url] = request.original_url if request.get?
  end


end
