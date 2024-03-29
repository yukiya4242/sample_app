class User < ApplicationRecord
    attr_accessor :remember_token, :activation_token
    before_save   :downcase_email
    before_create :create_activation_digest
    validates :name,  presence: true, length: { maximum: 50 }
    validates :password, presence: true, length: { minimum: 6 }
    VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

    validates :email, presence: true, length: { maximum: 255 },
                                      format: { with: VALID_EMAIL_REGEX },
                                      uniqueness: true

    has_secure_password

    validates :password, presence: true, length: { minimum: 6 }, allow_nil: true

     # 渡された文字列のハッシュ値を返す
      def User.digest(string)
        cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                      BCrypt::Engine.cost
        BCrypt::Password.create(string, cost: cost)
      end

      #ランダムなトークンを返す(Randomメソッド)
      def User.new_token
        SecureRandom.urlsafe_base64
      end

      #永続セッションのためにユーザーをDBに記憶する
      def remember
        self.remember_token = User.new_token
        self.update_attribute(:remember_digest, User.digest(remember_token))
      end

      def authenticated?(attribute, token)
        digest = send("#{attribute}_digest")
        return false if digest.nil?
        BCrypt::Password.new(digest).is_password?(token)
      end

      def forget
        self.update_attribute(:remember_digest, nil)
      end

      def activate
        update_attribute(:activated, true)
        update_attribute(:activated_at, Time.zone.now)
      end

      def send_activation_email
        UserMailer.account_activation(self).deliver_now
      end



      private

      #エールアドレスを全て小文字に変換
      def downcase_email
        self.email = email.downcase
      end

      # 有効化トークンとダイジェストを作成および代入する
      def create_activation_digest
        self.activation_token  = User.new_token
        self.activation_digest = User.digest(activation_token)
      end

end
