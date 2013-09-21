// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require jquery.ui.all
//= require_tree .
// Loads Bootstrap javascripts for accordions; note loading everything breaks other existing CSS/JS
//= require bootstrap-transition
//= require bootstrap-collapse


function refresh_buttons() {
   $('input:submit').button();
   $('button').button();
   $(".show_button").button({icons: {primary: "ui-icon-search"}, text: false });
   $(".edit_button").button({icons: {primary: "ui-icon-pencil"}, text: false });
   $(".trash_button").button({icons: {primary: "ui-icon-trash"}, text: false });
   $(".calendar_button").button({icons: {primary: "ui-icon-calendar"}, text: false });
   refresh_datetime_pickers();
}

$(document).ready(function() {
  refresh_buttons();
});



