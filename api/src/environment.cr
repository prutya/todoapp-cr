# Stdlib
require "http/server"
require "json"
require "uuid"
require "logger"

# 3-rd party libraries
require "clear"
require "cors"
require "jwt"
require "radix"

# Application
require "./models/base"
require "./models/*"
require "./dto/*"
require "./config"
require "./logger"
require "./request_store"
require "./handlers/utils"
require "./handlers/base"
require "./handlers/*"
require "./handlers/todos/*"
require "./handlers/sessions/*"
require "./handlers/users/*"
require "./server"

# Core extensions / monkey-patches
require "./ext/*"
