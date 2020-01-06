module App
  module Handlers
    class Ping < Base
      MSG_PONG = { message: "PONG" }

      def call(ctx)
        respond(ctx, HTTP::Status::OK, MSG_PONG)
      end
    end
  end
end
