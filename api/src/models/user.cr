module App
  module Models
    class User < Base
      include Clear::Model

      self.table = "users"

      has_many todos : Todo

      column id              : UUID, primary: true, presence: false
      column login           : String
      column password_digest : Crypto::Bcrypt::Password
      column locale          : String, presence: false
      column roles           : Array(String), presence: false
      column created_at      : Time, presence: false
      column updated_at      : Time, presence: false

      def password=(pwd)
        self.password_digest = Crypto::Bcrypt::Password.create(pwd)
      end
    end
  end
end
