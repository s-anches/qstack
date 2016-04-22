class User < ActiveRecord::Base
  has_many :questions, dependent: :destroy
  has_many :answers, dependent: :destroy
  has_many :votes, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :authorizations

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable,  omniauth_providers: [:facebook, :twitter, :vkontakte]

  def author_of?(object)
    id == object.user_id
  end

  def is_liked?(object)
    votes.where(votable: object).where('value > ?', 0).exists?
  end

  def voted?(object)
    votes.exists?(votable: object)
  end

  def self.find_for_oauth(auth)
    authorization = Authorization.where(provider: auth.provider, uid: auth.uid.to_s).first
    return authorization.user if authorization

    email = auth.info[:email]
    user = User.where(email: email).first
    if user
      user.create_authorization(auth) if user
    else
      password = Devise.friendly_token[0, 16]
      user = User.create!(email: email, password: password, password_confirmation: password)
      user.create_authorization(auth) if user
    end
    user
  end

  def create_authorization(auth)
    authorizations.create(provider: auth.provider, uid: auth.uid)
  end
end
