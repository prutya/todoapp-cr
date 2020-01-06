module App
  module Handlers
    # NOTE: Catches all exceptions and renders HTTP 500 Internal Server Error.
    class Error < Base
      def call(ctx : HTTP::Server::Context)
        call_next(ctx)
      rescue e : Exception
        log.error("#{ctx.store.id}: #{e.class} #{e.message} #{e.backtrace.join("\n")}")

        respond(ctx, HTTP::Status::INTERNAL_SERVER_ERROR)
      end
    end
  end
end
