class Predictors::IB1 < Predictors::Predictor
  
  def train(dataset)
    @predictor = Ai4r::Classifiers::IB1.new
    @predictor.build(dataset)
    self
  end
  
  def prepare_for_caching
    # Do nothing
  end

end