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
  
  describe 'paginate_for' do
    it "should response to method" do
      User.should respond_to('paginate_for')
    end
  
    it "should set the default action" do
      User.paginate_for
      User.paginate_actions.should == [:index]
    end

    it "should set an individial action" do
      User.paginate_for :find
      User.paginate_actions.should == [:find]
    end

    it "should set multiple actions" do
      User.paginate_for [:find, :seek, :index]
      User.paginate_actions.should == [:find, :seek, :index]
    end

  end
end
