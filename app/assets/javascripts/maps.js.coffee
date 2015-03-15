# Ensure app is available
window.Application ||= {}

# Create geo-locater class
class Application.Map
  
  # Enable debug
  @debug   = true

  add: (marker) ->
    marker = $(marker)
    this.log('add ' + marker.data('title') + ', [' + marker.data('lat') + ', ' + marker.data('lon') + ']')
  
    #if marker.data('lat') && marker.data('lon') && marker.data('title')
    @gmap.addMarker(
      lat:   marker.data('lat'),
      lng:   marker.data('lon'),
      title: marker.data('title'),
      click: ->
        Turbolinks.visit(marker.attr('href'))
    )

  fit: ->
    this.log('fit')

    # Calculate the new boundary
    bounds  = new google.maps.LatLngBounds()
    bounds.extend(marker.getPosition()) for marker in @gmap.markers
    
    # Assign to bounds
    @gmap.fitBounds(bounds)
    this.map.setZoom(15) if @gmap.getZoom() > 15

  log: (message) ->
    console.log( @map_id + ': ' + message)
  
  map: ->
    @gmap.map

  constructor: (@map_id = 'map') ->
    this.log('init')

    @gmap = new GMaps(
      div: '#' + @map_id,
      lat: 51.5072,
      lng: 0.1275
    )

    this.add(marker) for marker in $('[data-map=' + @map_id + ']') 
    this.fit()
