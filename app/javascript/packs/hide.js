$('document').ready(function(){
  // $('#card_to_use').hide()
  // $("#previous_card").change(function () {
  //   if (this.checked) {
  //     $("#new_card").hide()
  //     $('#card_to_use').show()
  //   } else if (!this.checked) {
  //     $("#new_card").show()
  //     $('#card_to_use').hide()
  //   }
  // })
  
  SpreedlyExpress.init("SSf1Qumf2kz5g3mmq7FLcQJSF8L", {
    "amount": document.getElementById('booking_total_price').val,
    "company_name": "Spreedly Airlines",
    "full_name": "First Last",
    "sidebar_top_description": "First in flight",
    "sidebar_bottom_description": "Your order total today",
  });
  SpreedlyExpress.onPaymentMethod(function(token, paymentMethod) {

    // Send requisite payment method info to backend
    var tokenField = document.getElementById("payment_method_token");
  
    tokenField.setAttribute("value", token);
  
    var masterForm = document.getElementById('payment-form');
  });
})
