# Ensure app is available
window.Application ||= {}

# Add to app
Application.addLocateToForm = (form) ->

  # Add located function
  form[0].located = (results) ->
    $(this).find("input[name=lat]").val(results.coords.latitude)
    $(this).find("input[name=lon]").val(results.coords.longitude)
    $(this).submit()
    this
    
  # Add locateFailed function
  form[0].locateFailed = (error) ->
    switch(error.code)
      when error.PERMISSION_DENIED then alert("User denied the request for Geolocation.")
      when error.POSITION_UNAVAILABLE then alert("Location information is unavailable.")
      when error.TIMEOUT then alert("The request to get user location timed out.")
      else alert("An unknown error occurred.")

  # Add locate function
  form[0].locate = () ->
    navigator.geolocation.getCurrentPosition(this.located, this.locateFailed, {timeout: 5000}) if navigator.geolocation
    this

  # Return the form
  form