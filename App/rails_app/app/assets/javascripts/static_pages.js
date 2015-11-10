// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

function update_micropost_content_count(){
  var area = document.getElementById('micropost_content'); 
  var counter = $('#counter')[0];
  if (area.addEventListener) {
    area.addEventListener('input', function() {
      var left = 140 - area.value.length;
      var char_word = left > 1? " characters" : " character";
      var text = left + char_word + " left";
      console.log(text);
      counter.textContent = text;
    }, false);
  } else if (area.attachEvent) {
    area.attachEvent('onpropertychange', function() {
      console.log(area.value);
    });
  }
}

$(document).ready(function(){
  update_micropost_content_count();
});

