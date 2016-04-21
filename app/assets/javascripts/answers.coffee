@bindClickEditAnswer = ->
  $('a.edit_answer').click (e) ->
    e.preventDefault()
    $('form.edit_question').hide()
    $('form.edit_answer').hide()
    $('form#new_answer').hide()
    answer_id = $(this).attr('id')
    $('form#edit_answer_' + answer_id).show()

@bindClickNewAnswer = ->
  $('a.link-new-answer').click (e) ->
    $('form.edit_question').hide()
    $('form.edit_answer').hide()
    $('form#new_answer').show()

$ ->
  bindClickEditAnswer()
  bindClickNewAnswer()

  questionId = $('.answers').data('questionId')

  PrivatePub.subscribe '/questions/' + questionId + '/answers', (data, channel) ->
    action = data['action']
    answer = $.parseJSON(data['answer'])
    attachments = $.parseJSON(data['attachments'])
    questionOwnerId = $.parseJSON(data['question_owner_id'])
    rating = data['rating']
    authorOfQuestion = gon.user_id == questionOwnerId ? true : false
    if gon.user_id != answer.user_id
      if action == 'create'
        $('.answers').prepend(HandlebarsTemplates['answers/create'](
          answer: answer, attachments: attachments,
          authorOfQuestion: authorOfQuestion
        ))
        bindClickClose()
        bindAddFiles()
        bindPlaceFiles()
        bindLinkVotes()
        bindAnswerComments()
      if action == 'update'
        $('div#answer-'+answer.id).remove()
        $('.answers').prepend(HandlebarsTemplates['answers/create'](
          answer: answer, attachments: attachments,
          authorOfQuestion: authorOfQuestion
        ))
        bindClickClose()
        bindAddFiles()
        bindPlaceFiles()
        bindLinkVotes()
        bindAnswerComments()
      if action == 'destroy'
        $('div#answer-'+answer.id).remove()
      if action == 'like' || action == 'dislike' || action == 'unvote'
        updateRating('answer', answer.id, rating)
