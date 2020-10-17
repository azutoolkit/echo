require "./echo/**"

module Echo
  VERSION = "0.1.0"
  CONFIG = Configuration.new
  REDIS = CONFIG.redis
end
