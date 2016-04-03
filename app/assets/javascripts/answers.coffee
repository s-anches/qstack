ready = ->
  $('.edit_answer').click (e) ->
    answer_id = $(this).attr('id')
    $('form#edit_answer_' + answer_id).show()

  $('.answer-link-like').bind "ajax:success", (e, data, status, xhr) ->
    answer_id = $(this).data('id')
    response = $.parseJSON(xhr.responseText)
    updateAnswerRating(response.rating, answer_id)
    $(this).addClass('liked not-active')
    $('#answer-'+answer_id+' .answer-link-dislike').addClass('not-active')
    $('#answer-'+answer_id+' .answer-link-unvote').removeClass('not-active')
  .bind "ajax:error", (e, xhr, status, error) ->
    response = $.parseJSON(xhr.responseText)
    $.each response, (index, value) ->
      $('#answer-'+answer_id+' .rating').after "<div class='error'>" + value + "</div>"

  $('.answer-link-dislike').bind "ajax:success", (e, data, status, xhr) ->
    answer_id = $(this).data('id')
    response = $.parseJSON(xhr.responseText)
    updateAnswerRating(response.rating, answer_id)
    $(this).addClass('disliked not-active')
    $('#answer-'+answer_id+' .answer-link-like').addClass('not-active')
    $('#answer-'+answer_id+' .answer-link-unvote').removeClass('not-active')
  .bind "ajax:error", (e, xhr, status, error) ->
    response = $.parseJSON(xhr.responseText)
    $.each response, (index, value) ->
      $('#answer-'+answer_id+' .rating').after "<div class='error'>" + value + "</div>"

  $('.answer-link-unvote').bind "ajax:success", (e, data, status, xhr) ->
    answer_id = $(this).data('id')
    response = $.parseJSON(xhr.responseText)
    updateAnswerRating(response.rating, answer_id)
    $(this).addClass('not-active')
    $('#answer-'+answer_id+' .answer-link-like').removeClass('liked not-active')
    $('#answer-'+answer_id+' .answer-link-dislike').removeClass('disliked not-active')
  .bind "ajax:error", (e, xhr, status, error) ->
    response = $.parseJSON(xhr.responseText)
    $.each response, (index, value) ->
      $('#answer-'+answer_id+' .rating').after "<div class='error'>" + value + "</div>"

$(document).ready(ready)
$(document).on('page:load', ready)
$(document).on('page:update', ready)

updateAnswerRating = (rating, answer_id) ->
  $("#answer-"+answer_id+" .votes-count").html("Rating: " + rating)