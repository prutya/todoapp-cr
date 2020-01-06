module App
  module Handlers
    module Todos
      class List < Action
        private def perform(ctx : HTTP::Server::Context)
          todos = Models::Todo.query.where { user_id == ctx.store.user.id }

          body = {
            data: todos.map do |todo|
              {
                id:   todo.id.to_s,
                body: todo.body
              }
            end
          }

          respond(ctx, HTTP::Status::OK, body)
        end
      end
    end
  end
end
