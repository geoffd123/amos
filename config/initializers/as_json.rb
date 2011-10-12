class ActiveRecord::Base

  # set the default as_json instance method, called when options is blank or equal to 'default'
  def self.as_json(opts)
    define_method "as_json" do |*options|
      if options.compact.blank? or options.to_s == 'default'
        super(opts)
      else
        super(*options)
      end
    end
  end

  # Does 2 thinks :
  #   - if an included assoc doesn't have any option, serialize it with its as_json method (todo should override active model/record serialization.rb but code has evolved between 3.0 and 3.1)
  #   - camelize recursively all the keys of the output
  def as_json(options={})
    options ||= {}
    options.symbolize_keys!
    includes = {}

    if options[:include]
      # control if a symbol or string is passed
      options[:include] = [options[:include]] unless options[:include].is_a?(Enumerable)

      options[:include].reject! do |assoc, opts|
        # if the included assoc does't have options, take the default association as_json, as defined in its model
        unless opts.is_a?(Hash)
          includes[assoc] = self.send(assoc).as_json
          true
        end
      end
    end
    super(options).update(includes).camelize_keys
  end

end

class ActiveSupport::TimeWithZone
  def as_json(options = {})
    strftime('%d/%m/%Y %H:%M:%S')
  end
end

