@bindClickEditAnswer = ->
  $('a.edit_answer').click (e) ->
    e.preventDefault()
    $('form.edit_answer').hide()
    $('form#new_answer').hide()
    $('form.edit_question').hide()
    answer_id = $(this).attr('id')
    $('form#edit_answer_' + answer_id).show()

$(document).ready(bindClickEditAnswer)
$ ->
  questionId = $('.answers').data('questionId')
  PrivatePub.subscribe '/questions/' + questionId + '/answers', (data, channel) ->
    answer = $.parseJSON(data['answer'])
    attachments = $.parseJSON(data['attachments'])
    question_id = $.parseJSON(data['question_id'])
    if gon.user_id != answer.user_id
      $('.answers').prepend(HandlebarsTemplates['answers/create'](answer: answer, attachments: attachments))
      bindClickEditQuestion()
      bindClickClose()
      bindAddFiles()
      bindPlaceFiles()
      bindLinkVotes()
      bindAnswerComments()
    if gon.user_id == question_id
      $('div[data-id="'+answer.id+'"][data-object="answer"] .best').html("<a href='/answers/"+answer.id+"/set_best' data-method='patch' data-remote='true'>Set best</a>")

  $('a.link-new-answer').click (e) ->
    $('form.edit_question').hide()
    $('form.edit_answer').hide()
    $('form#new_answer').show()