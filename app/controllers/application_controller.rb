require "application_responder"

class ApplicationController < ActionController::Base
  include Pundit

  self.responder = ApplicationResponder
  respond_to :html

  protect_from_forgery with: :exception

  before_filter :ensure_signup_complete, only: [:new, :create, :update, :destroy]
  before_action :gonify_user_id

  def ensure_signup_complete
    return if action_name == 'finish_signup'

    if current_user && !current_user.email_verified?
      redirect_to finish_signup_path(current_user)
    end
  end

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  private
    def gonify_user_id
      gon.user_id = user_signed_in? ? current_user.id : -1
    end

    def user_not_authorized(exception)
      policy_name = exception.policy.class.to_s.underscore
      flash[:alert] = t "#{policy_name}.#{exception.query}", scope: "pundit", default: :default
      redirect_to(request.referrer || root_path)
    end
end
