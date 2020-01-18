module App
  module Handlers
    module Utils
      extend self

      HEADER_CONTENT_TYPE = "Content-Type"

      BODY_NO_CONTENT = "{}"
      BODY_NO_CONTENT_SIZE = BODY_NO_CONTENT.bytesize

      CONTENT_TYPE_JSON = MIME::DEFAULT_TYPES[".json"]

      def respond(
        ctx : HTTP::Server::Context,
        status : HTTP::Status,
        data : Object? = nil
      )
        return if ctx.response.closed?

        ctx.response.status = status

        unless status == HTTP::Status::NO_CONTENT
          ctx.response.content_type = CONTENT_TYPE_JSON

          json = data.try(&.to_json)

          if body = json.as?(String)
            ctx.response.content_length = body.bytesize
            ctx.response << body
          else
            ctx.response.content_length = BODY_NO_CONTENT_SIZE
            ctx.response << BODY_NO_CONTENT
          end
        end

        ctx.response.flush
        ctx.response.close
      end

      def json_body_as?(
        ctx : HTTP::Server::Context,
        dto_class : App::Dto::Base.class
      )
        unless ctx.request.body
          respond(ctx, HTTP::Status::BAD_REQUEST)

          return nil
        end

        unless ctx.request.headers[HEADER_CONTENT_TYPE]? == CONTENT_TYPE_JSON
          respond(ctx, HTTP::Status::BAD_REQUEST)

          return nil
        end

        dto_class.from_json(ctx.request.body.not_nil!.gets_to_end)
      rescue e : JSON::ParseException
        respond(ctx, HTTP::Status::BAD_REQUEST)

        nil
      rescue e : JSON::MappingError
        respond(ctx, HTTP::Status::UNPROCESSABLE_ENTITY)

        nil
      end
    end
  end
end
