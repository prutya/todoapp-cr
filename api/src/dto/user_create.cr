module App
  module Dto
    struct UserCreate < Base
      JSON.mapping(
        {
          login: String,
          password: String
        },
        strict: true
      )
    end
  end
end
