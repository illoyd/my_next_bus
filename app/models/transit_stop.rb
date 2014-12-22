class TransitStop < ActiveRecord::Base
  
  def point
    @point ||= NotTfL::Point.new(self.latitude, self.longitude)
  end

end
