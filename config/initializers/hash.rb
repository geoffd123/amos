class Hash
  def camelize_keys(to = :lower)
    dup.camelize_keys!(to)
  end
  def camelize_keys!(to = :lower)
    each_pair do |key, value|
      if value.is_a?(Hash)
        self[key] = value.camelize_keys!(to)
      elsif value.is_a?(Array)
        self[key] = value.map{ |a| a.respond_to?('camelize_keys') ? a.camelize_keys(to) : a }
      end
      self[key.to_s.camelize(to)] = delete(key)
    end
    self
  end
  def underscore_keys
    dup.underscore_keys!
  end
  
  def underscore_keys!
    each_pair do |key, value|
      if value.is_a?(Hash)
        self[key] = value.underscore_keys!
      elsif value.is_a?(Array)
        self[key] = value.collect{|a| a.underscore_keys! }
      end
      self[key.to_s.underscore] = delete(key)
    end
    self
  end
  
  def replace_keys!(*keys_pairs)
    keys_pairs.flatten!
    keys_pairs.each do |keys_pair|
      old_key = keys_pair.keys.first
      new_key = keys_pair.values.first
      each_pair do |key, value|
        if value.is_a?(Hash)
          self[key] = value.replace_keys!(old_key, new_key)
        elsif value.is_a?(Array)
          self[key] = value.collect{|a| a.replace_keys!(old_key, new_key) }
        end
        if key.to_s == new_key.to_s
          self[new_key] = self[old_key]
        end
      end
    end
    self
  end
end