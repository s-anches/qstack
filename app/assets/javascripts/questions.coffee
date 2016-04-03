ready = ->
  $('.edit_question').click (e) ->
    $('form.edit_question').show()

  $('.question-link-like').bind "ajax:success", (e, data, status, xhr) ->
    response = $.parseJSON(xhr.responseText)
    updateRating(response.rating)
    $(this).addClass('liked not-active')
    $('.question-link-dislike').addClass('not-active')
    $('.question-link-unvote').removeClass('not-active')
  .bind "ajax:error", (e, xhr, status, error) ->
    response = $.parseJSON(xhr.responseText)
    $.each response, (index, value) ->
      $(".rating").after "<div class='error'>" + value + "</div>"

  $('.question-link-dislike').bind "ajax:success", (e, data, status, xhr) ->
    response = $.parseJSON(xhr.responseText)
    updateRating(response.rating)
    $(this).addClass('disliked not-active')
    $('.question-link-like').addClass('not-active')
    $('.question-link-unvote').removeClass('not-active')
  .bind "ajax:error", (e, xhr, status, error) ->
    response = $.parseJSON(xhr.responseText)
    $.each response, (index, value) ->
      $(".rating").after "<div class='error'>" + value + "</div>"

  $('.question-link-unvote').bind "ajax:success", (e, data, status, xhr) ->
    response = $.parseJSON(xhr.responseText)
    updateRating(response.rating)
    $(this).addClass('not-active')
    $('.question-link-like').removeClass('liked not-active')
    $('.question-link-dislike').removeClass('disliked not-active')
  .bind "ajax:error", (e, xhr, status, error) ->
    response = $.parseJSON(xhr.responseText)
    $.each response, (index, value) ->
      $(".rating").after "<div class='error'>" + value + "</div>"

$(document).ready(ready)
$(document).on('page:load', ready)
$(document).on('page:update', ready)

updateRating = (rating) ->
  $(".question .votes-count").html "Rating: " + rating