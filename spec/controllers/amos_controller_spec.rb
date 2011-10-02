require File.expand_path(File.dirname(__FILE__) + '/../../test/spec_helper')


describe Amos::AmosController do

  let(:user) {User.new(:email => 'smith@smith.com', :name => 'J Smith')}

  describe "routes" do
    it "routes /user to the index action" do
      { :get => "/user" }.
        should route_to(:controller => "amos/amos", :action => "index", :model => 'user')
    end

    it "routes show /user/1 to the show action" do
      { :get => "/users/1" }.
        should route_to(:controller => "amos/amos", :action => "show", :model => 'users', :id => '1')
    end

    it "routes delete /user/1 to the destroy action" do
      { :delete => "/users/1" }.
        should route_to(:controller => "amos/amos", :action => "destroy", :model => 'users', :id => '1')
    end
    
    it "routes put /user/1 to the update action" do
      { :put => "/users/1" }.
        should route_to(:controller => "amos/amos", :action => "update", :model => 'users', :id => '1')
    end

    it "routes put /user/1 to the create action" do
      { :post => "/users/1" }.
        should route_to(:controller => "amos/amos", :action => "create", :model => 'users', :id => '1')
    end

  end
  
  describe 'GET /user' do

    context 'successful operation' do
      before(:each) do
        User.should_receive('all'){[user]}
       end
       
      it "selects the correct model" do
        get :index, :model => 'user'
        assigns[:model].should == 'User'
      end

      it "calls the correct method" do
        get :index, :model => 'user'
      end
  
      it "returns the correct json data" do
        get :index, :model => 'user'
        ActiveSupport::JSON.decode(response.body).should == 
        ActiveSupport::JSON.decode([
            {"name" => "J Smith", "email"=>"smith@smith.com"}
        ].to_json)
      end
    end
  end
  
  describe 'GET /user/:id' do
    context 'successful operation' do
      before(:each) do
        User.should_receive('find').with(1){user}
      end

      it "selects the correct model" do
        get :show, :model => 'users', :id => '1'
        assigns[:model].should == 'User'
      end

      it "calls the correct method" do
        get :show, :model => 'users', :id => '1'
      end

      it "returns the correct json data" do
        get :show, :model => 'users', :id => '1'
        ActiveSupport::JSON.decode(response.body).should == 
        ActiveSupport::JSON.decode(
            {"name"=>"J Smith", "email"=>"smith@smith.com"}.to_json)
      end
    end
  end
  
  describe 'DELETE /user/:id' do
    
    context 'successful operation' do
      before(:each) do
        User.should_receive('find').with(1){user}
        user.should_receive('destroy')
      end

      it "selects the correct model" do
        delete :destroy, :model => 'users', :id => '1'
        assigns[:model].should == 'User'
      end

      it "calls the correct method" do
        delete :destroy, :model => 'users', :id => '1'
      end

      it "returns a success response" do
        delete :destroy, :model => 'users', :id => '1'
        ActiveSupport::JSON.decode(response.body).should == 
        ActiveSupport::JSON.decode(
            {"success"=>"true"}.to_json)
      end
    end

    context 'successful operation' do
      before(:each) do
        User.should_receive('find').with(1){RecordNotFound.new}
       end
      it "returns a fail response" do
         delete :destroy, :model => 'users', :id => '1'
        ActiveSupport::JSON.decode(response.body).should == 
        ActiveSupport::JSON.decode(
            {"success"=>"false"}.to_json)
      end
    end
  end

  describe 'PUT /user/:id' do
    context 'successful operation' do
      before(:each) do
        User.should_receive('find').with(1){user}
        user.should_receive('update_attributes').with('name' => 'fred', 'email' => 'smith'){true}
      end
      
      it "selects the correct model" do
        put :update, :model => 'users', :id => '1', :name => 'fred', :email => 'smith'
        assigns[:model].should == 'User'
      end

      it "calls the correct method" do
        put :update, :model => 'users', :id => '1', :name => 'fred', :email => 'smith'
      end

      it "returns a success response" do
        put :update, :model => 'users', :id => '1', :name => 'fred', :email => 'smith'
        ActiveSupport::JSON.decode(response.body).should == 
        ActiveSupport::JSON.decode(
            {"success"=>"true"}.to_json)
      end
    end
    
    context 'failed operation' do
      before(:each) do
        User.should_receive('find').with(1){user}
        user.should_receive('update_attributes').with('name' => 'fred', 'email' => 'smith'){false}
      end
      it "returns a fail response" do
        put :update, :model => 'users', :id => '1', :name => 'fred', :email => 'smith'
        ActiveSupport::JSON.decode(response.body).should == 
        ActiveSupport::JSON.decode(
            {"success"=>"false"}.to_json)
      end
    end
  end
  
  
end
