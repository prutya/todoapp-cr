module App
  module Handlers
    module Todos
      class Create < Action
        private def perform(ctx : HTTP::Server::Context)
          return unless dto = json_body_as?(ctx, Dto::TodoCreate)

          todo = Models::Todo.new.tap do |t|
            t.user_id = ctx.store.user.id
            t.body = dto.body

            t.save!
          end

          body = {
            id: todo.id.to_s,
            body: todo.body
          }

          respond(ctx, HTTP::Status::CREATED, body)
        end
      end
    end
  end
end
