module App
  module Models
    class Todo < Base
      include Clear::Model

      self.table = "todos"

      belongs_to user : User, key_type: UUID

      column id         : UUID, primary: true, presence: false
      column body       : String
      column created_at : Time, presence: false
      column updated_at : Time, presence: false
    end
  end
end
