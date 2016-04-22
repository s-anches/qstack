class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    @user = User.find_for_oauth(request.env["omniauth.auth"])

    if @user.persisted?
      render json: request.env['omniauth.auth']
    end
  end
end
