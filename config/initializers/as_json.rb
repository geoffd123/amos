# un peu moche mais le as_json fonctionnait pas en (Rails 3.0.7)
class ActiveRecord::Base

  def as_json(options={})
    super(options).camelize_keys
  end

end

class ActiveSupport::TimeWithZone
  def as_json(options = {})
    strftime('%d/%m/%Y %H:%M:%S')
  end
end
