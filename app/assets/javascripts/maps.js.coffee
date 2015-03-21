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
    #     @gmap.addMarker(
    #       lat:   marker.data('lat'),
    #       lng:   marker.data('lon'),
    #       title: marker.data('title'),
    #       click: ->
    #         Turbolinks.visit(marker.attr('href'))

    @gmap.drawOverlay(
      lat:   marker.data('lat'),
      lng:   marker.data('lon'),
      content: '<a href="' + marker.attr('href') + '" class="btn btn-danger btn-xs">' + marker.data('title') + '</a>'
      click: ->
        Turbolinks.visit(marker.attr('href'))
    )

  fit: ->
    this.log('fit')

    # Calculate the new boundary
    bounds  = new google.maps.LatLngBounds()
    # bounds.extend(marker.getPosition())  for marker  in @gmap.markers
    # this.log(overlay.latitude) for overlay in @gmap.overlays
    # bounds.extend(overlay.getBounds()) for overlay in @gmap.overlays
    bounds.extend(new google.maps.LatLng($(marker).data('lat'), $(marker).data('lon'))) for marker in $('[data-map=' + @map_id + ']') 
    
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
      lng: 0.1275,
      panControl:        false,
      mapTypeControl:    false,
      streetViewControl: false
    )

    this.add(marker) for marker in $('[data-map=' + @map_id + ']') 
    this.fit()
