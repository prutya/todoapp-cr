require "spec"

require "../src/environment"

config = App::Config.new
log    = App::Logger.new(config)

# NOTE: Disable the colorized output of Clear
Colorize.enabled = false

# NOTE: Initialize the database connection(s)
Clear.logger = log
Clear::SQL.init(config.db_url, config.db_connections)
