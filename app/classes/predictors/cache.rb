class Predictors::Cache
  
  DefaultExpiry = 24.hours
  
  def self.predictor_for(user)
    predictor = Redis.current.get(cache_key_for(user))
    if predictor
      predictor = Marshal.load(predictor)
    else
      predictor = build_predictor_for(user)
      set_predictor_for(user, predictor)
    end
    predictor
  end
  
  def self.set_predictor_for(user, predictor, expire_after = DefaultExpiry)
    Redis.current.setex(cache_key_for(user), expire_after, Marshal.dump(predictor))
  end
  
  def self.build_predictor_for(user)
    Predictors::IB1.train_for(user)
    
    rescue ArgumentError
      Predictors::Nil.new
  end
  
  def self.clear_for!(user)
    Redis.current.del(cache_key_for(user))
  end
  
  protected
  
  def self.cache_key_for(user)
    "user:#{ user.id }:predictor"
  end

end