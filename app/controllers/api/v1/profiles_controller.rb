class Api::V1::ProfilesController < ApplicationController
  protect_from_forgery with: :null_session
  before_action :doorkeeper_authorize!

  respond_to :json

  def me
    authorize :api
    respond_with current_resource_owner
  end
  
  def index
    authorize :api
    respond_with User.where.not(id: current_resource_owner)
  end

  protected
    def current_resource_owner
      @current_resource_owner ||= User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
    end

  private
    def pundit_user
      User.find(current_resource_owner.id)
    end

end