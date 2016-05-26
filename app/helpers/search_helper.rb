module SearchHelper
  def options_scope
    options = Search::SCOPES.map {|s| [t('.' + s), s]}
    options_for_select(options)
  end

  def select_search_scope
    select_tag :scope, options_scope, class: 'form-control'
  end

  def result_title(item)
    case item
    when Question
      link_to "Question \"#{item.title}\"", question_path(item.id)
    when Answer
      link_to "Answer for \"#{item.question.title}\"", question_path(item.question.id)
    when Comment
      if item.commentable_type == "Question"
        link_to "Comment for \"#{item.commentable.title}\"", question_path(item.commentable.id)
      else
        link_to "Comment for answer \"#{item.commentable.question.title}\"", question_path(item.commentable.question.id)
      end
    when User
      "User:"
    end    
  end

  def result_body(item)
    case item
    when User
      item.email
    else
      item.body
    end    
  end
end
