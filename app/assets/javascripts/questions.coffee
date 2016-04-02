ready = ->
  $('.edit_question').click (e) ->
    $('form.edit_question').show();

  $('.question-link-like').bind "ajax:success", (e, data, status, xhr) ->
    response = $.parseJSON(xhr.responseText)
    updateRating(response.rating)
  .bind "ajax:error", (e, xhr, status, error) ->
    response = $.parseJSON(xhr.responseText)
    $.each response, (index, value) ->
      $("#votes").after "<div class='error'>" + value + "</div>"

$(document).ready(ready)
$(document).on('page:load', ready)
$(document).on('page:update', ready)

updateRating = (rating) ->
  $(".question .votes-count").html "Rating: " + rating