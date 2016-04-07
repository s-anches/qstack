ready = ->
  $('.edit_question').click (e) ->
    $('form.edit_question').show()

  $('.link-like').bind "ajax:success", (e, data, status, xhr) ->
    data = this.dataset
    response = $.parseJSON(xhr.responseText)
    updateRating(data.object, data.id, response.rating)
    $(this).addClass('liked not-active')
    $(".link-dislike[data-object='"+data.object+"'][data-id='"+data.id+"']").addClass('not-active')
    $(".link-unvote[data-object='"+data.object+"'][data-id='"+data.id+"']").removeClass('not-active')
  .bind "ajax:error", (e, xhr, status, error) ->
    console.log(xhr.responseText)
    response = $.parseJSON(xhr.responseText)
    $.each response, (index, value) ->
      $("div[data-object='"+data.object+"'][data-id='"+data.id+"'] .rating").after "<div class='error'>" + value + "</div>"

  $('.link-dislike').bind "ajax:success", (e, data, status, xhr) ->
    data = this.dataset
    response = $.parseJSON(xhr.responseText)
    updateRating(data.object, data.id, response.rating)
    $(this).addClass('disliked not-active')
    $(".link-like[data-object='"+data.object+"'][data-id='"+data.id+"']").addClass('not-active')
    $(".link-unvote[data-object='"+data.object+"'][data-id='"+data.id+"']").removeClass('not-active')
  .bind "ajax:error", (e, xhr, status, error) ->
    response = $.parseJSON(xhr.responseText)
    $.each response, (index, value) ->
      $("div[data-object='"+data.object+"'][data-id='"+data.id+"'] .rating").after "<div class='error'>" + value + "</div>"

  $('.link-unvote').bind "ajax:success", (e, data, status, xhr) ->
    data = this.dataset
    response = $.parseJSON(xhr.responseText)
    updateRating(data.object, data.id, response.rating)
    $(this).addClass('not-active')
    $(".link-like[data-object='"+data.object+"'][data-id='"+data.id+"']").removeClass('liked not-active')
    $(".link-dislike[data-object='"+data.object+"'][data-id='"+data.id+"']").removeClass('disliked not-active')
  .bind "ajax:error", (e, xhr, status, error) ->
    response = $.parseJSON(xhr.responseText)
    $.each response, (index, value) ->
      $("div[data-object='"+data.object+"'][data-id='"+data.id+"'] .rating").after "<div class='error'>" + value + "</div>"

$(document).ready(ready)
$(document).on('page:load', ready)
$(document).on('page:update', ready)

updateRating = (object, id, rating) ->
  $("div[data-object='"+object+"'][data-id='"+id+"'] .rating .votes-count").html "Rating: " + rating