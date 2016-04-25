class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :find_user

  def show
  end

  def finish_signup
    if request.patch? && params[:user] && params[:user][:email]
      if User.where(email: params[:user][:email]).first
        user = User.where(email: params[:user][:email]).first
        authorization = Authorization.where(user: @user).first
        authorization.user = user
        authorization.save!

        user.unconfirmed_email = params[:user][:email]
        user.save!
        user.send_confirmation_instructions

        flash[:error] = "User with this email already exist! We send email to confirm this!"
        @user.destroy!
        redirect_to root_path
      else
        if @user.update(user_params)
          redirect_to root_path, notice: 'Check you mail. We send email to confirm account.'
        else
          @show_errors = true
        end
      end
    end
  end

  private
    def find_user
      @user = User.find(params[:id])
    end

    def user_params
      accessible = [ :email ]
      accessible << [ :password, :password_confirmation ] unless params[:user][:password].blank?
      params.require(:user).permit(accessible)
    end
end
