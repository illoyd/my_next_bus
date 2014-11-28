class Predictors::Hyperpipes < Predictors::Predictor
  
  def train(dataset)
    @predictor = Ai4r::Classifiers::Hyperpipes.new
    @predictor.build(dataset)
    self
  end

end