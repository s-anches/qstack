class Comments::CreateSerializer < CommentSerializer
  has_one :user
end