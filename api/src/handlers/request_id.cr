module App
  module Handlers
    class RequestId < Base
      def call(ctx : HTTP::Server::Context)
        ctx.store.id = req_id = UUID.random.to_s

        log.debug("#{req_id}: Connected")

        call_next(ctx)
      end
    end
  end
end
