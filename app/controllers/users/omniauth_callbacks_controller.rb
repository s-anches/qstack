class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  before_action :provides_callback

  def facebook
  end

  def twitter
  end

  def vkontakte
  end

  def after_sign_in_path_for(resource)
    if resource.email_verified?
      super resource
    else
      finish_signup_path(resource)
    end
  end

  private
    def provides_callback
      @user = User.find_for_oauth(env["omniauth.auth"], current_user) if env["omniauth.auth"]

      if @user && @user.persisted?
        sign_in_and_redirect @user, event: :authentication
        set_flash_message(:notice, :success, kind: self.action_name.capitalize) if is_navigational_format?
      else
        flash[:error] = "Could not authenticate you! Invalid credential!"
        session["devise.#{action_name}_data"] = env["omniauth.auth"]
        redirect_to new_user_registration_url
      end
    end
end
