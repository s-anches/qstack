@bindClickNewComment = ->
  $('a.link-new-comment').click (e) ->
    e.preventDefault()
    $('form.edit_question').hide()
    $('form.edit_answer').hide()
    $('form#new_comment').hide()
    $(this).parent().find('form#new_comment').show()

@bindAnswerComments = ->
  $('div.answer').each (index, element) =>
    answerId = $(element).data("id")
    PrivatePub.subscribe '/answers/' + answerId + '/comments', (data, channel) ->
      comment = $.parseJSON(data['comment'])
      if gon.user_id != comment.user_id
        $('div[data-id="'+answerId+'"][data-object="answer"] .comments').append(comment.body)

$ ->
  bindClickNewComment()
  bindAnswerComments()
  questionId = $('.question').data('id')
  PrivatePub.subscribe '/questions/' + questionId + '/comments', (data, channel) ->
    comment = $.parseJSON(data['comment'])
    if gon.user_id != comment.user_id
      $('div[data-id="'+questionId+'"][data-object="question"] .comments').append(comment.body)

