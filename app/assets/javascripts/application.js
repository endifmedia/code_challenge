
//= require jquery
//= require bootstrap-sprockets
//= require_tree .
document.addEventListener("DOMContentLoaded", function(){

  var select = document.getElementById('coupon_select');
  
  if (select) {
    select.addEventListener("change", function(){
      document.getElementById("coupon_search_button").disabled=false
    })
  }

});