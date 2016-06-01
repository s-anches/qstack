class User < ActiveRecord::Base
  TEMP_EMAIL_PREFIX = 'oauth@provided'
  TEMP_EMAIL_REGEX = /\Aoauth@provided/

  has_many :questions, dependent: :destroy
  has_many :answers, dependent: :destroy
  has_many :votes, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :authorizations, dependent: :destroy
  has_many :subscriptions, dependent: :destroy

  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable,
         omniauth_providers: [:facebook, :twitter, :vkontakte, :github, :instagram]

  validates_format_of :email, :without => TEMP_EMAIL_REGEX, on: :update

  def author_of?(object)
    id == object.user_id
  end

  def is_liked?(object)
    votes.where(votable: object).where('value > ?', 0).exists?
  end

  def voted?(object)
    votes.exists?(votable: object)
  end

  def subscribed?(object)
    subscriptions.exists?(question: object)
  end

  def subscribe(object)
    subscriptions.create(question: object) unless subscribed?(object)
  end

  def unsubscribe(object)
    subscription = subscriptions.find_by(question: object)
    subscription.destroy if subscription
  end

  def self.find_for_oauth(auth, signed_in_resource = nil)
    info = auth.info
    raw_info = auth.extra.raw_info

    authorization = Authorization.find_for_oauth(auth)

    user = signed_in_resource ? signed_in_resource : authorization.user

    if user.nil?
      email = info.email || raw_info.email
      user = User.where(email: email).first if email

      if user.nil?
        user = User.new(
          email: email ? email : "#{TEMP_EMAIL_PREFIX}-#{auth.uid}.#{auth.provider}",
          password: Devise.friendly_token[0,16]
        )
        user.skip_confirmation!
        user.save!
      end
    end

    if authorization.user != user
      authorization.user = user
      authorization.save!
    end
    user
  end

  def email_verified?
    self.email && self.email !~ TEMP_EMAIL_REGEX
  end

end
