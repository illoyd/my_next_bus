# # Ensure app is available
# window.Application ||= {}
# 
# # Add auto-redirect to button
# Application.addAutoRedirectToControl = (index) ->
#   _control = this
#   
#   # Assign starting seconds
#   this.secondsRemaining = 10
#   
#   # Start countdown
#   this.startCountDown = () ->
#     _control.stopCountdown() if _control.hasCountdownTimer
#     _control.countdownTimer = setTimeout(doAutoRefresh, page_refresh_interval);
#   
#   # Stop countdown
#   this.stopCountdown = () ->
#     if (_control.hasCountdownTimer)
#       clearInterval(_control.countdownTimer)
#       _control.countdownTimer = null
#   
#   # Has countdown
#   this.hasCountdownTimer = () ->
#     _control.countdownTimer != null
#   
#   # Do countdown tick
#   this.doCountdownTick = () ->
#     _control.secondsRemaining--
#     
#     if !_control.hasCountdownTimer
#       $(_control).find('.btn-go').innerText = "Go!"
# 
#     elsif _control.secondsRemaining > 0
#       $(_control).find('.btn-go').innerText = "Go in " + _control.secondsRemaining + "!"
# 
#     else
#       $(_control).find('.btn-go').innerText = "Going!"
#       Turbolinks.visit($(_control).data('data-redirector-url')
#   
#   # Add actions to buttons
#   $(this).find("button.btn-no").on('click', _form.stopCountdown)
# 
# # Update all forms 
# Application.addAutoRedirectToControls = () ->
#   $("div[data-redirector=true]").each(Application.addAutoRedirectToControl)
# 
# # Update on page load
# $(document).ready(Application.addAutoRedirects)
# $(document).on('page:load', Application.addAutoRedirects)