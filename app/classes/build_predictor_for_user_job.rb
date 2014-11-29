class BuildPredictorForUserJob < ActiveJob::Base
  queue_as :background

  def perform(user)
    Predictors::Cache.clear_for!(user)
    Predictors::Cache.predictor_for(user)
  end

end
