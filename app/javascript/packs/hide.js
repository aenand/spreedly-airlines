$('document').ready(function(){
  $("#previous_card").change(function () {
    if (this.checked) {
      $("#new_card").hide()
    } else if (!this.checked) {
      $("#new_card").show()
    }
  })
})
