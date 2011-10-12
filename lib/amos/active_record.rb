class ActiveRecord::Base
  def self.list(options={})
    options ||={}
    where(options)
  end
end