module App
  module Dto
    struct TodoCreate < Base
      JSON.mapping(
        {
          body: String
        },
        strict: true
      )
    end
  end
end
