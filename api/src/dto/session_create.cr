module App
  module Dto
    struct SessionCreate < Base
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
