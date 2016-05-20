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

@bindSubscribeLink = ->
  $('.link-subscribe').bind "ajax:success", (e, data, status, xhr) ->
    $('.subscription').html("You subscribed for this question.")
  .bind "ajax:error", (e, xhr, status, error) ->
    console.log("Subscribe error")

@bindUnsubscribeLink = ->
  $('.link-unsubscribe').bind "ajax:success", (e, data, status, xhr) ->
    $('.unsubscription').html("You unsubscribed for this question.")
  .bind "ajax:error", (e, xhr, status, error) ->
    console.log("Unsubscribe error")

@bindLinkVotes = ->
  $('.link-like, .link-dislike, .link-unvote').bind "ajax:success", (e, data, status, xhr) ->
    e.preventDefault()
    data = this.dataset
    response = $.parseJSON(xhr.responseText)
    updateRating(data.object, data.id, response.rating)

    if data.action == 'like' || data.action == 'dislike'
      $('#'+data.object+'-'+data.id+' .votes .like, #'+data.object+'-'+data.id+' .votes .dislike').remove()
      $('#'+data.object+'-'+data.id+' #vote-links').append('<li class="unvote"><a class="link-unvote" data-type="json" data-id="'+data.id+'" data-object="'+data.object+'" data-action="unvote" data-remote="true" rel="nofollow" data-method="delete" data-confirm="Вы уверены что хотите отменить голос?" href="/'+data.object+'s/'+data.id+'/unvote">Unvote</a></li>')
    if data.action == 'unvote'
      $('#'+data.object+'-'+data.id+' .votes .unvote').remove()
      $('#'+data.object+'-'+data.id+' #vote-links').append('<li class="dislike"><a class="link-dislike" data-type="json" data-id="'+data.id+'" data-object="'+data.object+'" data-action="dislike" data-remote="true" rel="nofollow" data-method="patch" href="/'+data.object+'s/'+data.id+'/dislike">-</a></li>')
      $('#'+data.object+'-'+data.id+' #vote-links').append('<li class="like"><a class="link-like" data-type="json" data-id="'+data.id+'" data-object="'+data.object+'" data-action="like" data-remote="true" rel="nofollow" data-method="patch" href="/'+data.object+'s/'+data.id+'/like">+</a></li>')
    bindLinkVotes()
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
  bindSubscribeLink()
  bindUnsubscribeLink()

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
