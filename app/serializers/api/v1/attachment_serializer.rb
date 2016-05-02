class Api::V1::AttachmentSerializer < ActiveModel::Serializer
  attributes :id, :url

  def url
    object.file.url
  end
end
