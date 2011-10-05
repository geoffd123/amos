
require "amos"
require "rails"

module Amos
  class Engine < Rails::Engine
    paths.app.controllers << "lib/controllers"
  end
end