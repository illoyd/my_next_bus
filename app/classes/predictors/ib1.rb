class Predictors::IB1 < Predictors::Predictor
  
  def train(dataset)
    @predictor = Ai4r::Classifiers::IB1.new
    @predictor.build(dataset)
    self
  end

end