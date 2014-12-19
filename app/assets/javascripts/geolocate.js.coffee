# Ensure app is available
window.Application ||= {}

# Add to app
Application.addLocateToForm = (index) ->
  _form = this
  console.log(this)

  # Add located function
  this.located = (results) ->
    $(_form).find("input[name=lat]").val(results.coords.latitude)
    $(_form).find("input[name=lon]").val(results.coords.longitude)
    _form.submit()
    _form
    
  # Add locateFailed function
  this.locateFailed = (error) ->
    switch(error.code)
      when error.PERMISSION_DENIED then alert("To use the Find Me button you must allow us to access your location. Please refresh your browser and try again.")
      when error.POSITION_UNAVAILABLE then alert("Sorry, location information is currently unavailable. Try turning on your device's Wi-Fi, GPS, or Location Services.")
      when error.TIMEOUT then alert("Sorry, your device took a long time to locate you. Try again soon!")
      else alert("An unknown error occurred. Try again soon!")

  # Add locate function
  this.locate = () ->
    success = (results) ->
      _form.located(results)

    failed = (error) ->
      _form.locateFailed(error)

    navigator.geolocation.getCurrentPosition( _form.located, _form.locateFailed, {timeout: 10000, maximumAge: 30000}) if navigator.geolocation
    this
  
  # Attach locate event to button!
  $(_form).find("button[data-locater-button=true]").on('click', _form.locate)

  # Return the form
  _form

# Update all forms 
Application.addLocateToForms = () ->
  $("form[data-locater=true]").each(Application.addLocateToForm)

# Update on page load
$(document).ready(Application.addLocateToForms)
$(document).on('page:load', Application.addLocateToForms)