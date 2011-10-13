class User < ActiveRecord::Base
  has_many :recipes
  validates_presence_of :email
  
  def as_json(options={})
    opts = { :except => [:created_at, :updated_at]}
    opts.merge!(options) unless options.nil?
    super(opts)
  end

end
