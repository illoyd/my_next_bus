class Predictors::Nil < Predictors::Predictor
  
  def train(dataset)
    @predictor = nil
    self
  end
  
end