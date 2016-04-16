module ConcernHelpers::VotableHelper
  DIRECTION = { like: '+', dislike: '-', unvote: 'Unvote' }
  METHODS = { like: :patch, dislike: :patch, unvote: :delete }
  CONFIRMS = { like: "", dislike: "", unvote: "Вы уверены что хотите отменить голос?" }
  CLASSES = { like: '', dislike: '', unvote: '' }

  def direction_sign(direction)
    DIRECTION[direction.to_sym]
  end

  def method_sign(direction)
    METHODS[direction.to_sym]
  end

  def confirm_sign(direction)
    CONFIRMS[direction.to_sym]
  end

  def classes_sign(direction)
    CLASSES[direction.to_sym]
  end

  def vote_link(object, direction)
    if current_user.voted?(object)
      if current_user.is_liked?(object)
        CLASSES[:like] = 'liked not-active'
        CLASSES[:dislike] = 'not-active'
        CLASSES[:unvote] = ''
      else
        CLASSES[:like] = 'not-active'
        CLASSES[:dislike] = 'disliked not-active'
        CLASSES[:unvote] = ''
      end
    else
      CLASSES[:like] = ''
      CLASSES[:dislike] = ''
      CLASSES[:unvote] = 'not-active'
    end

    link_to direction_sign(direction), [direction, object], method: method_sign(direction),
      remote: true, class: "link-#{direction} #{classes_sign(direction)}",
      data: { id: object.id, object: klass_name(object), confirm: confirm_sign(direction), action: direction }
  end
end