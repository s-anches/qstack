class Api::V1::BaseController < ApplicationController
  protect_from_forgery with: :null_session
  before_action :doorkeeper_authorize!
  before_action :find_user, only: :create

  respond_to :json

  protected
    def current_resource_owner
      @current_resource_owner ||= User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
    end

  private
    def find_user
      @user = User.find(current_resource_owner.id)
    end
    
    def pundit_user
      User.find(current_resource_owner.id)
    end
end