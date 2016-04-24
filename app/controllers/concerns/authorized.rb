module Authorized
  extend ActiveSupport::Concern

  included do
    before_filter :ensure_signup_complete, only: [:new, :create, :update, :destroy]
  end
end

