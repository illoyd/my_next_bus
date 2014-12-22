class Predictors::MultilayerPerceptron < Predictors::Predictor
  
  def train(dataset)
    @predictor = Ai4r::Classifiers::MultilayerPerceptron.new
    @predictor.set_parameters(:hidden_layers, [8,6])
    @predictor.build(dataset)
    self
  end

end