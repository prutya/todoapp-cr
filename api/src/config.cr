module App
  struct Config
    getter auth_secret    : String
    getter db_connections : Int32
    getter db_url         : String
    getter log_format     : String
    getter log_severity   : String
    getter server_bind    : String
    getter server_cors    : Array(String)

    def initialize(env = ENV.to_h)
      @auth_secret    = env["TODOAPP_AUTH_SECRET"]
      @db_connections = env["TODOAPP_DB_CONNECTIONS"].to_i
      @db_url         = env["TODOAPP_DB_URL"]
      @log_format     = env["TODOAPP_LOG_FORMAT"]
      @log_severity   = env["TODOAPP_LOG_SEVERITY"].upcase
      @server_bind    = env["TODOAPP_SERVER_BIND"]
      @server_cors    = env["TODOAPP_SERVER_CORS"].split(";")
    end
  end
end
