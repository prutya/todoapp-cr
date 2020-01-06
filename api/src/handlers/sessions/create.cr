module App
  module Handlers
    module Sessions
      class Create < Action
        SESSION_DURATION = 10.days

        private def skip_auth?
          true
        end

        private def perform(ctx : HTTP::Server::Context)
          return unless dto = json_body_as?(ctx, Dto::SessionCreate)

          unless user = Models::User.query.find { login == dto.login.downcase }
            return respond(ctx, HTTP::Status::UNAUTHORIZED)
          end

          unless user.password_digest.verify(dto.password)
            return respond(ctx, HTTP::Status::UNAUTHORIZED)
          end

          current_time = Time.utc
          body = {
            jwt: JWT.encode(
              {
                "user_id" => user.id.to_s,
                "iat"     => current_time.to_unix,
                "exp"     => (current_time + SESSION_DURATION).to_unix
              },
              config.auth_secret,
              JWT::Algorithm::HS256
            )
          }

          respond(ctx, HTTP::Status::CREATED, body)
        end
      end
    end
  end
end
