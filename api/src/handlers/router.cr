module App
  module Handlers
    class Router < Base
      alias HandlerData = NamedTuple(
        path:    String,
        method:  String,
        handler: Base
      )

      @tree : Radix::Tree(Base)

      def initialize(
        routes : Array(HandlerData),
        **other
      )
        super(**other)

        @tree = Radix::Tree(Base).new.tap do |tree|
          routes.each do |handler_data|
            tree.add(
              radix_path(handler_data[:method], handler_data[:path]),
              handler_data[:handler]
            )
          end
        end
      end

      def call(ctx : HTTP::Server::Context)
        result =
          @tree.find(radix_path(ctx.request.method, ctx.request.path))

        unless result.found?
          return respond(ctx, HTTP::Status::NOT_FOUND)
        end

        ctx.store.route_params = result.params

        result.payload.call(ctx)
      end

      private def radix_path(method : String, path : String)
        "/#{method.upcase}#{path}"
      end
    end
  end
end
