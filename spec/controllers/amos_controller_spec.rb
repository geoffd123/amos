require File.expand_path(File.dirname(__FILE__) + '/../../test/spec_helper')


describe Amos::AmosController do

  let(:user) {User.new(:email => 'smith@smith.com', :name => 'J Smith')}

  describe 'GET /user' do

    it "should route to amos controller#all" do
      assert_recognizes({ :controller => "amos/amos", :action => "all", :model => 'user'}, "/user")
    end
    
    it "selects the correct model" do
      get :all, :model => 'user'
      assigns[:model].should == 'User'
    end

    it "calls the correct method" do
      User.should_receive('all').with(){[user]}
      get :all, :model => 'user'
    end
  
    it "returns the correct json data" do
      User.should_receive('all'){[user]}
      get :all, :model => 'user'
      ActiveSupport::JSON.decode(response.body).should == 
      ActiveSupport::JSON.decode([
          {"name" => "J Smith", "email"=>"smith@smith.com"}
      ].to_json)
    end
  end
  
  describe 'GET /user/:id' do
    it "should route to amos controller#with_id" do
      assert_recognizes({ :controller => "amos/amos", :action => "get_with_id", :model => 'user', :id => '1'}, "/user/1")
    end

    it "selects the correct model" do
      User.should_receive('find').with(1){user}
      get :get_with_id, :model => 'user', :id => '1'
      assigns[:model].should == 'User'
    end

    it "calls the correct method" do
      User.should_receive('find').with(1){user}
      get :get_with_id, :model => 'user', :id => '1'
    end

    it "returns the correct json data" do
      User.should_receive('find').with(1){user}
      get :get_with_id, :model => 'user', :id => '1'
      ActiveSupport::JSON.decode(response.body).should == 
      ActiveSupport::JSON.decode(
          {"name"=>"J Smith", "email"=>"smith@smith.com"}.to_json)
    end
  end
  
  describe 'DELETE /user/:id' do
    it "should route to amos controller#with_id" do
      assert_recognizes({ :controller => "amos/amos", :action => "delete_with_id", :model => 'user', :id => '1'}, {:path => 'user/1', :method => :delete})
    end

    it "selects the correct model" do
      User.should_receive('find').with(1){user}
      user.should_receive('destroy')
      delete :delete_with_id, :model => 'user', :id => '1'
      assigns[:model].should == 'User'
    end

    it "calls the correct method" do
      User.should_receive('find').with(1){user}
      user.should_receive('destroy')
      delete :delete_with_id, :model => 'user', :id => '1'
    end

    it "returns a success response" do
      User.should_receive('find').with(1){user}
      user.stub('destroy')
      delete :delete_with_id, :model => 'user', :id => '1'
      ActiveSupport::JSON.decode(response.body).should == 
      ActiveSupport::JSON.decode(
          {"success"=>"true"}.to_json)
    end

    it "returns a fail response" do
      User.should_receive('find').with(1){RecordNotFound.new}
      delete :delete_with_id, :model => 'user', :id => '1'
      ActiveSupport::JSON.decode(response.body).should == 
      ActiveSupport::JSON.decode(
          {"success"=>"false"}.to_json)
    end
  end
  
end
