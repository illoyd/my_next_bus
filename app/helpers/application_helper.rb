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

  ##
  # Create a label
  def llabel(text, kind = :default)
    content_tag(:span, text, class: [ 'label', "label-#{ kind }" ].compact)
  end

  def photo_tag_for(user)
    image_tag(user.try(:photo_url) || image_path('default.png'), style: 'height: 30px;')
  end
end
