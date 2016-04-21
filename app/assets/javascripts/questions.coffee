@bindClickEditQuestion = ->
  $('a.edit_question').click (e) ->
    e.preventDefault()
    $('form.edit_answer').hide()
    $('form#new_answer').hide()
    $('form.edit_question').show()

  $('.edit_question input:submit').click (e) ->
    $('form.edit_question').hide()

@bindClickClose = ->
  $('.link-close').click (e) ->
    e.preventDefault()
    $(this).parent().parent().parent().css("display", "none")

@bindAddFiles = ->
  $('.new_question, .new_answer, .edit_answer, .edit_question')
  .on 'change', '.btn-file :file', () ->
    input = $(this).parents('.input-group').find(':text')
      .val $(this).val().replace(/\\/g, '/').replace(/.*\//, '')

@bindPlaceFiles = ->
  $("a.add_fields")
    .data "association-insertion-method", 'append'
    .data "association-insertion-node", (link) ->
      return link.closest('.form-group').parent().find('.attachments_form')

@bindLinkVotes = ->
  $('.link-like, .link-dislike, .link-unvote').bind "ajax:success", (e, data,status, xhr) ->
    e.preventDefault()
    data = this.dataset
    response = $.parseJSON(xhr.responseText)
    updateRating(data.object, data.id, response.rating)

    if data.action == 'like'
      $(this).addClass('liked not-active')
      $(".link-dislike[data-object='"+data.object+"'][data-id='"+data.id+"']").addClass('not-active')
      $(".link-unvote[data-object='"+data.object+"'][data-id='"+data.id+"']").removeClass('not-active')

    if data.action == 'dislike'
      $(this).addClass('disliked not-active')
      $(".link-like[data-object='"+data.object+"'][data-id='"+data.id+"']").addClass('not-active')
      $(".link-unvote[data-object='"+data.object+"'][data-id='"+data.id+"']").removeClass('not-active')

    if data.action == 'unvote'
      $(this).addClass('not-active')
      $(".link-like[data-object='"+data.object+"'][data-id='"+data.id+"']").removeClass('liked not-active')
      $(".link-dislike[data-object='"+data.object+"'][data-id='"+data.id+"']").removeClass('disliked not-active')

  .bind "ajax:error", (e, xhr, status, error) ->
    response = $.parseJSON(xhr.responseText)
    $.each response, (index, value) ->
      $("#errors").append(value)

@updateRating = (object, id, rating) ->
  $('div#'+object+'-'+id+' .rating').html("<h6>Rating:</h6><h3>"+rating+"</h3>")

$ ->
  bindClickEditQuestion()
  bindClickClose()
  bindAddFiles()
  bindPlaceFiles()
  bindLinkVotes()

  PrivatePub.subscribe '/questions', (data, channel) ->
    action = data['action']
    question = $.parseJSON(data['question'])
    if action == 'create'
      $('.questions').prepend(HandlebarsTemplates['questions/create'](question: question))
    if action == 'update'
      $('div#question-'+question.id).remove()
      $('.questions').prepend(HandlebarsTemplates['questions/create'](question: question))
    if action == 'destroy'
      $('div#question-'+question.id).remove()
