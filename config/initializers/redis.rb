if ENV[ ENV['REDIS_PROVIDER'] || 'REDIS_URL' ]
  Redis.current = Redis.new(url: ENV[ ENV['REDIS_PROVIDER'] || 'REDIS_URL' ])
end