module App
  module Handlers
    abstract class Base
      include HTTP::Handler

      private getter config : Config
      private getter log    : ::Logger

      def initialize(@config : Config, @log : ::Logger); end

      abstract def call(ctx : HTTP::Server::Context)

      delegate respond, json_body_as?, to: Utils
    end
  end
end
