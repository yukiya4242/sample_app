module SessionsHelper

  def login(user)
    session[:user_id] = user.id
  end

  def current_user
    #current_userがnilかどうかはsession_idがあるか、つまり一度でもログインしているか
    if session[:user_id]
      #DBへの問い合わせをできる限り小さくしたい↓
      @current_user ||= User.find_by(id: session[:user_id])
    end
  end

  #ユーザーがログインしてるのか確認。
  def logged_in?
    #[!]はnotオペレーターと呼ばれる
    #current_userがnilではない(つまり存在するなら) => ture
    #current_userがnil(つまり存在しないなら) => false
    !current_user.nil?
  end

end
