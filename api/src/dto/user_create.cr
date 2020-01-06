module App
  module Dto
    struct UserCreate
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
