require "application_responder"

class ApplicationController < ActionController::Base
  self.responder = ApplicationResponder
  respond_to :html

  protect_from_forgery with: :exception

  before_action :gonify_user_id

  private
    def gonify_user_id
      gon.user_id = user_signed_in? ? current_user.id : -1
    end
end
