
require "amos"
require "rails"

module Amos
  class Engine < Rails::Engine
    paths.app.controllers << "lib/controllers"
    config.active_record.include_root_in_json = false
  end
end