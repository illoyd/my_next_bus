class Predictors::NaiveBayes < Predictors::Predictor
  
  def train(dataset)
    @predictor = Ai4r::Classifiers::NaiveBayes.new
    @predictor.build(dataset)
    self
  end

end