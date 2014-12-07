module ApplicationHelper
  
  def emoji(string)
    EMOJI[string] || EMOJI[:not_found]
  end
  
  ##
  # Create a font-awesome icon
  def icon( kind = :blank, options = {} )
    kind = ICONS.fetch(kind, kind.to_s.gsub(/_/, '-'))
    options[:class] = [ 'glyphicon', "glyphicon-#{kind}", options[:class] ].compact
    content_tag(:i, '', options)
  end
  
  ##
  # Prefix a string with an icon
  def iconify(label, icon, options = {})
    "#{ icon(icon, options) } #{ label }".strip.html_safe
  end
  
  def favorite_icon(toggle)
    icon(toggle ? :star : 'star-empty')
  end

  ##
  # Create a label
  def llabel(text, kind = :default)
    content_tag(:span, text, class: [ 'label', "label-#{ kind }" ].compact)
  end

  def photo_tag_for(user)
    image_tag(user.try(:photo_url) || image_path('default.png'), style: 'height: 30px;')
  end
  
  def favorite_toggle(path, toggle, options = {})
    link_to(path, options) { favorite_icon(toggle) }
  end
  
  def favorite_toggle_button(path, toggle, options = {})
    favorite_toggle(path, toggle, merge_favorite_toggle_button_options(toggle, options))
  end
  
  def favorite_stop_toggle(stop_sid, favorites, options = {})
    favorite_toggle_button(
      favorite_london_stop_path(stop_sid),
      favorites.include?(stop_sid),
      options
    )
  end
  
  def favorite_destination_toggle(destination, favorites, options = {})
    favorite_toggle_button(
      favorite_london_destination_path(destination),
      favorites.include?(destination),
      options
    )
  end
  
  def default_favorite_toggle_button_options(toggle)
    {
      class: (toggle ? 'favorite' : 'not-favorite')
    }
  end
  
  def merge_favorite_toggle_button_options(toggle, options)
    opt = default_favorite_toggle_button_options(toggle)
    options = options.with_indifferent_access
    options[:class] = [ opt[:class], options[:class] ] if options.include? :class
    options[:style] = [ opt[:style], options[:style] ] if options.include? :style
    opt.merge(options)
  end
  
  def stop_destination_favorite_toggle(stop, destination, favorites, options = {})
    path   = favorite_london_stop_path(stop.code1, {destination: destination})
    toggle = favorites.include?(destination)
    favorite_toggle(path, toggle, options)
  end
  
  def favorite_stop_for_line_toggle(stop, line, favorites, options = {})
    path   = favorite_london_trip_path(line, {stop_sid: stop})
    toggle = favorites.include?(stop)
    favorite_toggle(path, toggle, options)
  end

end
