module ApplicationHelper
  
  def emoji(string)
    EMOJI[string] || EMOJI[:not_found]
  end
end
