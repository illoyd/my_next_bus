namespace :mynextbus do
  namespace :predictors do

    task :refresh => :environment do
      BuildablePredictorUsersQuery.new.each { |user| BuildPredictorForUserJob.perform_later(user) }
    end

  end
end