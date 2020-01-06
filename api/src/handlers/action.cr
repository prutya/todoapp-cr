module App
  module Handlers
    abstract class Action < Base
      HEADER_AUTHORIZATION = "Authorization"
      JWT_KEY_USER_ID = "user_id"

      def call(ctx : HTTP::Server::Context)
        req_id = ctx.store.id

        if skip_auth?
          log.debug("#{req_id}: Skipped authentication")
        else
          unless jwt = ctx.request.headers[HEADER_AUTHORIZATION]?.as?(String)
            log.debug("#{req_id}: Authorization header is missing")

            return respond(ctx, HTTP::Status::UNAUTHORIZED)
          end

          jwt_payload_any =
            begin
              _jwt_payload_any, _ =
                JWT.decode(jwt, config.auth_secret, JWT::Algorithm::HS256)

              _jwt_payload_any
            rescue e : JWT::Error
              log.debug("#{req_id}: JWT error: #{e.message}")

              return respond(ctx, HTTP::Status::UNAUTHORIZED)
            end

          unless jwt_payload = jwt_payload_any.as_h?
            log.debug("#{req_id}: JWT is not a hash")

            return respond(ctx, HTTP::Status::UNAUTHORIZED)
          end

          unless user_id_string = jwt_payload[JWT_KEY_USER_ID]?.as?(JSON::Any).try(&.as_s?)
            log.debug("#{req_id}: user_id key is missing")

            return respond(ctx, HTTP::Status::UNAUTHORIZED)
          end

          unless user_id = UUID.from_s?(user_id_string)
            log.debug("#{req_id}: user_id key is not a UUID")

            return respond(ctx, HTTP::Status::UNAUTHORIZED)
          end

          unless user = Models::User.find(user_id).as?(Models::User)
            log.debug("#{req_id}: User does not exist")

            return respond(ctx, HTTP::Status::UNAUTHORIZED)
          end

          log.debug("#{req_id}: Authenticated as User #{user.id}")

          ctx.store.user = user
        end

        perform(ctx)
      end

      private def skip_auth?
        false
      end

      private abstract def perform(ctx : HTTP::Server::Context)
    end
  end
end
