module ApplicationHelper
  
  def emoji(string)
    EMOJI[string] || EMOJI[:not_found]
  end
  
  def photo_tag_for(user)
    image_tag(user.try(:photo_url) || image_path('default.png'), style: 'height: 30px;')
  end
end
