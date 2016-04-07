ready = ->
  $('.edit_answer').click (e) ->
    answer_id = $(this).attr('id')
    $('form#edit_answer_' + answer_id).show()

$(document).ready(ready)
$(document).on('page:load', ready)
$(document).on('page:update', ready)