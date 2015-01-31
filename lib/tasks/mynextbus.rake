namespace :mynextbus do
  namespace :predictors do

    task :refresh => :environment do
      # Enqueue jobs for building predictors
      BuildablePredictorUsersQuery.new.each { |user| BuildPredictorForUserJob.perform_later(user) }
      
      # Wakey wakey little server
      HTTPClient.new.get_content('http://www.mynextbus.co.uk')
    end

  end
end