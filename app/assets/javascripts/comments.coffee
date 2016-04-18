@bindClickNewComment = ->
  $('a.link-new-comment').click (e) ->
    e.preventDefault()
    $('form.edit_question').hide()
    $('form.edit_answer').hide()
    $('form#new_comment').hide()
    $(this).parent().find('form#new_comment').show()

$ ->
  bindClickNewComment()