class BuildablePredictorUsersQuery < SimpleDelegator

  def initialize(base = User)
    __setobj__ base.where('last_sign_in_at >= ?', 2.weeks.ago)
  end
  
end
