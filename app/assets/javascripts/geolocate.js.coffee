# Ensure app is available
window.Application ||= {}

# Add to app
Application.addLocateToForm = (index) ->
  ff = this
  console.log(ff)

  # Add located function
  ff.located = (results) ->
    $(ff).find("input[name=lat]").val(results.coords.latitude)
    $(ff).find("input[name=lon]").val(results.coords.longitude)
    ff.submit()
    ff
    
  # Add locateFailed function
  ff.locateFailed = (error) ->
    switch(error.code)
      when error.PERMISSION_DENIED then alert("User denied the request for Geolocation.")
      when error.POSITION_UNAVAILABLE then alert("Location information is unavailable.")
      when error.TIMEOUT then alert("The request to get user location timed out.")
      else alert("An unknown error occurred.")

  # Add locate function
  ff.locate = () ->
    success = (results) ->
      ff.located(results)

    failed = (error) ->
      ff.locateFailed(error)

    navigator.geolocation.getCurrentPosition( ff.located, ff.locateFailed, {timeout: 10000, maximumAge: 30000}) if navigator.geolocation
    this
  
  # Attach locate event to button!
  $(ff).find("button[data-locater-button=true]").on('click', ff.locate)

  # Return the form
  ff

# Update all forms 
Application.addLocateToForms = () ->
  $("form[data-locater=true]").each(Application.addLocateToForm)

# Update on page load
$(document).ready(Application.addLocateToForms)
$(document).on('page:load', Application.addLocateToForms)