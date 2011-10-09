module AmosPagination
  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods
    def paginate_results
      @paginate_actions = ['index', 'find']
    end
    
    def paginate_actions
      @paginate_actions ||= []
    end

  end
  
end

