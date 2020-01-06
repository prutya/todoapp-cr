module App
  module Handlers
    module Users
      class Show < Action
        private def perform(ctx : HTTP::Server::Context)
          unless route_id = ctx.store.route_params["id"]?.as?(String)
            return respond(ctx, HTTP::Status::NOT_FOUND)
          end

          if route_id == "current"
            return respond(ctx, HTTP::Status::OK, construct_body(ctx.store.user))
          end

          if UUID.from_s?(route_id) == ctx.store.user.id
            return respond(ctx, HTTP::Status::OK, construct_body(ctx.store.user))
          end

          respond(ctx, HTTP::Status::NOT_FOUND)
        end

        private def construct_body(user)
          {
            id:     user.id.to_s,
            login:  user.login,
            locale: user.locale,
            roles:  user.roles
          }
        end
      end
    end
  end
end
