module App
  module Dto
    struct TodoCreate
      JSON.mapping(
        {
          body: String
        },
        strict: true
      )
    end
  end
end
