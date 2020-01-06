module App
  struct Server
    @http_server : HTTP::Server?

    def initialize(@config : Config, @log : Logger); end

    def listen
      return if @http_server

      @http_server = server = HTTP::Server.new([
        Handlers::RequestId.new(@config, @log),
        Handlers::Error.new(@config, @log),
        Handlers::Timing.new(@config, @log),
        Cors.new(
          respond_ok: ->(ctx : HTTP::Server::Context) do
            Handlers::Utils.respond(ctx, HTTP::Status::OK); nil
          end,
          log: @log,
          log_prefix: ->(ctx : HTTP::Server::Context) { "#{ctx.store.id}: " },
          allowed_origins: @config.server_cors,
          allowed_methods: ["GET", "POST", "PUT", "PATCH", "DELETE", "HEAD"],
          allowed_headers: ["Authorization", "Content-Type", "Accept", "X-Requested-With"]
        ),
        Handlers::Router.new(
          config: @config,
          log: @log,
          routes: [
            {
              path: "/ping",
              method: "GET",
              handler: Handlers::Ping.new(@config, @log)
            },
            {
              path: "/todos",
              method: "POST",
              handler: Handlers::Todos::Create.new(@config, @log)
            },
            {
              path: "/todos",
              method: "GET",
              handler: Handlers::Todos::List.new(@config, @log)
            },
            {
              path: "/todos/:id",
              method: "GET",
              handler: Handlers::Todos::Show.new(@config, @log)
            },
            {
              path: "/todos/:id",
              method: "PATCH",
              handler: Handlers::Todos::Update.new(@config, @log)
            },
            {
              path: "/todos/:id",
              method: "DELETE",
              handler: Handlers::Todos::Destroy.new(@config, @log)
            },
            {
              path: "/sessions",
              method: "POST",
              handler: Handlers::Sessions::Create.new(@config, @log)
            },
            {
              path: "/users/:id",
              method: "GET",
              handler: Handlers::Users::Show.new(@config, @log)
            },
            {
              path: "/users",
              method: "POST",
              handler: Handlers::Users::Create.new(@config, @log)
            },
          ]
        )
      ])

      @log.info("Starting server on #{@config.server_bind}")

      server.bind(@config.server_bind)

      server.listen
    end

    def close
      return unless @http_server

      @http_server.as(HTTP::Server).close
    end
  end
end
