# Ensure app is available
window.Application ||= {}

# Create geo-locater class
class Application.GeoLocater

  constructor: (@form) ->
    @debug = true

  # Located callback
  # Used when geolocation is successful
  located: (results) ->
    console.log('located') if @debug
    @form.find("input[name=lat]").val(results.coords.latitude)
    @form.find("input[name=lon]").val(results.coords.longitude)
    @form.submit()
    
  # LocateFailed callback
  # Used when geolocation fails
  locateFailed: (error) ->
    console.log('locateFailed') if @debug
    switch(error.code)
      when error.PERMISSION_DENIED then alert("To use the Find Me button you must allow us to access your location. Please refresh your browser and try again.")
      when error.POSITION_UNAVAILABLE then alert("Sorry, location information is currently unavailable. Try turning on your device's Wi-Fi, GPS, or Location Services.")
      when error.TIMEOUT then alert("Sorry, your device took a long time to locate you. Try again soon!")
      else alert("An unknown error occurred. Try again soon!")

  # Locate
  # Find the user!
  locate: () ->
    console.log('locate') if @debug
    navigator.geolocation.getCurrentPosition( this.located.bind(this), this.locateFailed.bind(this), {timeout: 10000, maximumAge: 30000}) if navigator.geolocation
    this

# Update all forms 
Application.bindLocateButtons = () ->
  Application.geo_locater = new Application.GeoLocater($("form#geolocater")) if !Application.geo_locater?
  $("button[data-locater=true]").click(Application.geo_locater.locate.bind(Application.geo_locater))

# Update on page load
$(document).ready(Application.bindLocateButtons)
$(document).on('page:load', Application.bindLocateButtons)