$('document').ready(function(){
  $('#card_to_use').hide()
  $("#previous_card").change(function () {
    if (this.checked) {
      $("#new_card").hide()
      $('#card_to_use').show()
    } else if (!this.checked) {
      $("#new_card").show()
      $('#card_to_use').hide()
    }
  })
})
