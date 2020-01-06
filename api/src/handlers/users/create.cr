module App
  module Handlers
    module Users
      class Create < Action
        private def skip_auth?
          true
        end

        private def perform(ctx : HTTP::Server::Context)
          return unless dto = json_body_as?(ctx, Dto::UserCreate)

          # TODO: Now returns the whole user. Can be optimized
          if Models::User.query.find { login == dto.login.downcase }
            return respond(ctx, HTTP::Status::CONFLICT)
          end

          user = Models::User.new.tap do |u|
            u.login    = dto.login.downcase
            u.password = dto.password

            u.save!
          end

          body = {
            id: user.id.to_s,
            login: user.login,
            locale: user.locale,
            roles: user.roles
          }

          respond(ctx, HTTP::Status::CREATED, body)
        end
      end
    end
  end
end
