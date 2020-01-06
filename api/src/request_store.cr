module App
  struct RequestStore
    property! id           : String?
    property! route_params : Hash(String, String)?
    property! user         : Models::User
  end
end
