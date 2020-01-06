module App
  module Dto
    struct SessionCreate
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
