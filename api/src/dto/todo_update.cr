module App
  module Dto
    struct TodoUpdate < Base
      JSON.mapping(
        {
          body: String
        },
        strict: true
      )
    end
  end
end
