module AmosPagination
  @@items_per_page = 10  

  def self.per_page
    @@items_per_page
  end

  def self.items_per_page=(num)
    @@items_per_page = num.to_i
  end
 
end


class ActiveRecord::Base
  include AmosPagination

  def self.paginate_for action=:index
    @paginate_actions ||= []
    @paginate_actions << action
    p "setting paginate for #{self}"
  end
      
end

