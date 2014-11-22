if ENV["REDISCLOUD_URL"]
  Redis.current = Redis.new(:url => ENV["REDISCLOUD_URL"])
end