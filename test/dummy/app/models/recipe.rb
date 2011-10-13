class Recipe < ActiveRecord::Base
  belongs_to :user
  
  def as_json(options={})
    opts = { :except => [:created_at, :updated_at]}
    opts.merge!(options) unless options.nil?
    super(opts)
  end

end
