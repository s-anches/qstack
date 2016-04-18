$ ->
  $('a.link-new-comment').click (e) ->
    $('form.edit_question').hide()
    $('form.edit_answer').hide()
    $('form#new_comment').show()