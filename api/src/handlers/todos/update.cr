module App
  module Handlers
    module Todos
      class Update < Action
        private def perform(ctx : HTTP::Server::Context)
          unless route_id = ctx.store.route_params["id"]?.as?(String)
            return respond(ctx, HTTP::Status::NOT_FOUND)
          end

          unless todo_id = UUID.from_s?(route_id)
            return respond(ctx, HTTP::Status::NOT_FOUND)
          end

          return unless dto = json_body_as?(ctx, Dto::TodoUpdate)

          todo_nilable = Models::Todo.query.find {
            (user_id == ctx.store.user.id) & (id == todo_id)
          }

          unless todo = todo_nilable.as?(Models::Todo)
            return respond(ctx, HTTP::Status::NOT_FOUND)
          end

          todo.body = dto.body
          todo.save!

          body = {
            id: todo.id.to_s,
            body: todo.body
          }

          respond(ctx, HTTP::Status::OK, body)
        end
      end
    end
  end
end
