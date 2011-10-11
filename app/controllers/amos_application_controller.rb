class ApplicationController < ActionController::Base

  def set_association_keys_for(klass, hash)
    hash.replace_keys(klass.reflections.keys.flatten.map { |name| { "#{name}" => "#{name}_attributes"} })
  end

end