class Predictors::Predictor
  
  attr_reader :predictor
  
  ##
  # Create a new Predictor trained for the given user.
  def self.train_for(user)
    new.train_for(user)
  end
  
  ##
  # Train the predictor for the given user.
  def train_for(user)
    dataset = Predictors::StopRequestDataset.for(user)
    train(dataset)
  end
  
  ##
  # Create and train the predictor given a dataset. Should be overriden.
  def train(dataset)
    raise 'Override me!'
  end
  
  ##
  # Predict the stop based on the +day_of_week+ and +minute_of_day+.
  def predict(day_of_week, minute_of_day)
    @predictor.eval([day_of_week, minute_of_day])
  end
  
  ##
  # Predict the stop based on the current date and time.
  def predict_now
    timestamp     = Time.now
    day_of_week   = timestamp.wday
    minute_of_day = timestamp.hour * 60 + timestamp.min
    predict(day_of_week, minute_of_day)
  end
  
end