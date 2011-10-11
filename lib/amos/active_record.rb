class ActiveRecord::Base
  def self.list(options)
    where(options)
  end
end