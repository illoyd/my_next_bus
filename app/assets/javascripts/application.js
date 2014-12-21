// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require bootstrap-sprockets
//= require turbolinks
//= require_tree .


function geolocateMe() {
  if (navigator.geolocation) {
    navigator.geolocation.getCurrentPosition(submitSearch, showError);
  }
};

function submitSearch(results) {
  console.log(results.coords.longitude);
  $("#lat").val(results.coords.latitude);
  $("#lon").val(results.coords.longitude);
  $("#search").submit();  
};

function showError(error) {
  switch(error.code) {
      case error.PERMISSION_DENIED:
          console.log("User denied the request for Geolocation.");
          break;
      case error.POSITION_UNAVAILABLE:
          console.log("Location information is unavailable.");
          break;
      case error.TIMEOUT:
          console.log("The request to get user location timed out.");
          break;
      case error.UNKNOWN_ERROR:
          console.log("An unknown error occurred.");
          break;
  }
};