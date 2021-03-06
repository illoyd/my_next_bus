# Ensure app is available
window.Application ||= {}

# Location Timer!
class Application.LocationTimer

  constructor: (@url, @interval) ->
    @secondsRemaining = @interval
    @timestamp        = Date.now() + @interval * 1000
    @timer            = null
    @debug            = true
    
    # Add a listener to stop when page changes
    $(document).on("page:before-change", this.stop.bind(this));

  # Start countdown
  start: () ->
    console.log('start') if @debug
    this.stop() if this.hasTimer()
    @timer = setInterval(this.doTick.bind(this), 1000);
  
  # Stop countdown
  stop: () ->
    console.log('stop') if @debug
    if (this.hasTimer())
      clearInterval(@timer)
      @timer = null
  
  # Reset
  reset: () ->
    console.log('reset') if @debug
    @secondsRemaining = @interval
    @timestamp        = Date.now() + @interval * 1000
  
  # Toggle
  toggle: () ->
    if this.hasTimer()
      this.stop()
      false
    else
      this.reset()
      this.start()
      true
  
  # Has countdown
  hasTimer: () ->
    console.log('hasTimer? ' + (@timer != null)) if @debug
    @timer != null
  
  # Do countdown tick
  doTick: () ->
    @secondsRemaining = Math.floor( (@timestamp - Date.now()) / 1000 )
    console.log('doTick: ' + @secondsRemaining) if @debug
    if @secondsRemaining <= 0 || @timestamp <= Date.now()
      this.stop()
      Turbolinks.visit(@url)

##
# Refresh Timer is used to visit a given page and to control the timer through a single button.
class Application.RefreshTimer extends Application.LocationTimer

  ##
  # The default interval for auto-refreshes, in seconds
  @defaultInterval = 30

  constructor: (@url, @interval, @control) ->
    super(@url, @interval)
    @control.on('click', this.toggle.bind(this))
  
  # Start countdown
  start: () ->
    super
    this.updateCounter()
    @control.addClass('on')
    @control.removeClass('hidden')
  
  stop: () ->
    super
    @control.removeClass('on')

  doTick: () ->
    super
    this.updateCounter()
  
  updateCounter: () ->
    @control.find("span.counter")[0].innerText = @secondsRemaining

##
# Suggestion Timer visits a given page and has one control with the countdown and another to stop.
class Application.SuggestionTimer extends Application.LocationTimer

  ##
  # The default interval for suggestions, in seconds
  @defaultInterval = 15

  constructor: (@url, @interval, @go_control, @stop_control) ->
    super(@url, @interval)
    @stop_control.on('click', this.stop.bind(this))
  
  start: () ->
    super
    this.updateCounter()
    @go_control.addClass('with-counter')

  stop: () ->
    super
    @go_control.removeClass('with-counter')

  doTick: () ->
    super
    this.updateCounter()
  
  updateCounter: () ->
    @go_control.find("span.counter")[0].innerText = @secondsRemaining
