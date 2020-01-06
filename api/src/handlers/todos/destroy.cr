module App
  module Handlers
    module Todos
      class Destroy < Action
        private def perform(ctx : HTTP::Server::Context)
          unless route_id = ctx.store.route_params["id"]?.as?(String)
            return respond(ctx, HTTP::Status::NOT_FOUND)
          end

          unless todo_id = UUID.from_s?(route_id)
            return respond(ctx, HTTP::Status::NOT_FOUND)
          end

          todo_nilable = Models::Todo.query.find {
            (user_id == ctx.store.user.id) & (id == todo_id)
          }

          unless todo = todo_nilable.as?(Models::Todo)
            return respond(ctx, HTTP::Status::NOT_FOUND)
          end

          todo.delete

          respond(ctx, HTTP::Status::NO_CONTENT)
        end
      end
    end
  end
end
