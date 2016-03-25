// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
$(function() {
  $(document).on("click", ".edit_answer", function() {
    id = $(this).attr('id')
    $('form#edit_answer_' + id).show();
  });
});