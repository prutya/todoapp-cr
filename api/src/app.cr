require "./environment"

config = App::Config.new
log    = App::Logger.new(config)

# NOTE: Disable the colorized output of Clear
Colorize.enabled = false

# NOTE: Initialize the database connection(s)
Clear.logger = log
Clear::SQL.init(config.db_url, config.db_connections)

server = App::Server.new(config, log)

on_shutdown = -> do
  log.info("Server shutting down")

  server.close

  log.info("Bye!")
  exit 0
end

Signal::INT.trap { on_shutdown.call }
Signal::TERM.trap { on_shutdown.call }

server.listen
