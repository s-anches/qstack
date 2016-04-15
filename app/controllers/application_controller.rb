class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :gonify_user_id

  private
    def gonify_user_id
      gon.user_id = user_signed_in? ? current_user.id : -1
    end
end
