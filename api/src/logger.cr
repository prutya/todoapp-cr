module App
  class Logger < ::Logger
    FORMAT_JSON = "json"
    FORMAT_NULL = "null"

    FORMATTER_JSON =
      ::Logger::Formatter.new do |severity, datetime, _progname, message, io|
        io << {
          severity: severity.to_s,
          time: datetime,
          pid: Process.pid,
          message: message
        }.to_json
      end

    def initialize(config : Config)
      common_args = {
        io: if config.log_format == FORMAT_NULL
              File.open(File::NULL, "w")
            else
              STDOUT
            end,
        level: ::Logger::Severity.parse(config.log_severity)
      }

      if config.log_format == FORMAT_JSON
        super(**common_args, formatter: FORMATTER_JSON)
      else
        super(**common_args)
      end
    end
  end
end
