require File.expand_path(File.dirname(__FILE__) + '/../../test/spec_helper')
require 'lib/amos/pagination'

class ActiveRecord::Base
  include AmosPagination
end

class User < ActiveRecord::Base
end

describe User do
  
  let(:user) {User.new(:email => 'smith@smith.com')}

  it "should response to items_per_page" do
    User.should respond_to('per_page')
  end
  
  describe 'paginate_results' do
    it "should response to method" do
      User.should respond_to('paginate_results')
    end
  
    it "should set the default actions" do
      User.paginate_results
      User.paginate_actions.should == ['index', 'find']
    end
  end
end
