class Predictors::ID3 < Predictors::Predictor
  
  def train(dataset)
    @predictor = Ai4r::Classifiers::ID3.new
    @predictor.build(dataset)
    self
  end

end