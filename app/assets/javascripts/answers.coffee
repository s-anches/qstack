@bindClickEditAnswer = ->
  $('a.edit_answer').click (e) ->
    e.preventDefault()
    $('form.edit_answer').hide();
    answer_id = $(this).attr('id')
    $('form#edit_answer_' + answer_id).show()

$(document).ready(bindClickEditAnswer)