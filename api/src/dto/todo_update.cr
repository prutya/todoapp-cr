module App
  module Dto
    struct TodoUpdate
      JSON.mapping(
        {
          body: String
        },
        strict: true
      )
    end
  end
end
