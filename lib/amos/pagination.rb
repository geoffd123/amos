module AmosPagination
  def self.included(base)
    base.extend(ClassMethods)
  end
  
  module ClassMethods
    def paginate_for action = :index
      @paginate_actions = []
      if action.is_a?(Array)
        action.each{|a| @paginate_actions << a}
      else
        @paginate_actions << action
      end
    end
    
    def paginate_actions
      @paginate_actions ||= []
    end

  end
  
end

