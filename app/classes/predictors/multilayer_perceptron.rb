class Predictors::MultilayerPerceptron < Predictors::Predictor
  
  def train(dataset)
    @predictor = Ai4r::Classifiers::MultilayerPerceptron.new
    @predictor.build(dataset)
    self
  end

end