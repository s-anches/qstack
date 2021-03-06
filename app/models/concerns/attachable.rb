module Attachable
  extend ActiveSupport::Concern

  included do
    has_many :attachments, as: :attachable, dependent: :destroy
    accepts_nested_attributes_for :attachments,
      reject_if: proc{ |param| param[:file].blank? },
      allow_destroy: true
  end
end