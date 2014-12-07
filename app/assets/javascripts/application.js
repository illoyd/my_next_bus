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


// Page Refresh Timer - used for starting and stopping page refreshes.
page_refresh_timer = null;

// Page refresh interval, in milliseconds.
page_refresh_interval = 15 * 1000;

function toggleAutorefresh() {
  if (page_refresh_timer != null) {
    stopAutoRefresh();
  } else {
    startAutoRefresh();
  }
}

function updateAutorefreshButton() {
  toggle = page_refresh_timer != null;
  class_to_add    = toggle ? 'on' : 'off';
  class_to_remove = !toggle ? 'on' : 'off';

  $("#autorefresh").addClass(class_to_add);
  $('#autorefresh').data('autorefresh', class_to_add);
  $("#autorefresh").removeClass(class_to_remove);
  $("#autorefresh").removeClass('hidden');
  console.log("Toggling refresh button: " + $('#autorefresh').data('autorefresh'));
};

// Start page refreshes
function startAutoRefresh() {
  stopAutoRefresh();
  page_refresh_timer = setTimeout(doAutoRefresh, page_refresh_interval);
  console.log("Started auto refresh timer.");
  updateAutorefreshButton();
};

// Stop page refreshes
function stopAutoRefresh() {
  if (page_refresh_timer != null) {
    console.log("Stopping auto refresh timer.")
    clearTimeout(page_refresh_timer);
    page_refresh_timer = null;
  }
  updateAutorefreshButton();
};

// Perform a page refresh
function doAutoRefresh() {
  console.log("Performing auto refresh.")
  page_refresh_timer = null;
  Turbolinks.visit(location.toString());
};

// Always turn off page refreshes when moving to a new page
$(document).on("page:before-change", stopAutoRefresh)