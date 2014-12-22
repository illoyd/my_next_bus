class Predictors::Prism < Predictors::Predictor
  
  def train(dataset)
    @predictor = Ai4r::Classifiers::Prism.new
    @predictor.build(dataset)
    self
  end

end