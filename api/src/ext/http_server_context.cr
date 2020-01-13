module HTTP
  class Server
    class Context
      getter store : App::RequestStore

      def initialize(
        @request : Request,
        @response : Response,
        @store = App::RequestStore.new
      ); end
    end
  end
end
