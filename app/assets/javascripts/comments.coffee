@bindClickNewComment = ->
  $('a.link-new-comment').click (e) ->
    e.preventDefault()
    $('form.edit_question').hide()
    $('form.edit_answer').hide()
    $('form#new_comment').hide()
    $(this).parent().find('form#new_comment').show()

$ ->
  bindClickNewComment()
  questionId = $('.question').data('id')
  PrivatePub.subscribe '/questions/' + questionId + '/comments', (data, channel) ->
    action = data['action']
    comment = $.parseJSON(data['comment'])
    if gon.user_id != comment.user_id
      console.log(comment)
      $('div#'+comment.commentable_type.toLowerCase()+'-'+comment.commentable_id+' .comments')
        .append("<p>"+comment.body+"</p>")
