require File.expand_path(File.dirname(__FILE__) + '/../../test/spec_helper')
require 'factory_girl'

describe AmosController do

  let(:user) {FactoryGirl.build(:user)}
  let(:recipe) {Factory.build(:recipe, :name => 'Boiled eggs', :description => 'Grab an egg', :user => user)}

  describe "routes" do
    it "routes /user to the index action" do
      { :get => "/user" }.
        should route_to(:controller => "amos", :action => "index", :model => 'user')
    end

    it "routes show /user/1 to the show action" do
      { :get => "/users/1" }.
        should route_to(:controller => "amos", :action => "show", :model => 'users', :id => '1')
    end

    it "routes delete /user/1 to the destroy action" do
      { :delete => "/users/1" }.
        should route_to(:controller => "amos", :action => "destroy", :model => 'users', :id => '1')
    end
    
    it "routes put /user/1 to the update action" do
      { :put => "/users/1" }.
        should route_to(:controller => "amos", :action => "update", :model => 'users', :id => '1')
    end

    it "routes post /user to the create action" do
      { :post => "/users" }.
        should route_to(:controller => "amos", :action => "create", :model => 'users')
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
 
  describe 'GET /user?fields=' do

    context 'successful operation' do
      before(:each) do
        User.should_receive('all'){[user, user]}
       end
       
      it "selects the correct model" do
        get :index, :model => 'user', :fields => 'email'
        assigns[:model].should == 'User'
      end

      it "calls the correct method" do
        get :index, :model => 'user', :fields => 'email'
      end
  
      it "determines the correct fields" do
        get :index, :model => 'user', :fields => 'email'
        assigns[:the_fields].should == ['email']
      end
  
      it "returns the correct json data" do
        get :index, :model => 'user', :fields => 'email'
        ActiveSupport::JSON.decode(response.body).should == 
        ActiveSupport::JSON.decode([
          {"email"=>"smith@smith.com"},
          {"email"=>"smith@smith.com"}
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

  describe 'GET /user/:id?fields=' do

    context 'successful operation' do
      before(:each) do
        User.should_receive('find').with(1){user}
       end
       
      it "selects the correct model" do
        get  :show, :model => 'users', :id => '1', :fields => 'email'
        assigns[:model].should == 'User'
      end

      it "calls the correct method" do
        get  :show, :model => 'users', :id => '1', :fields => 'email'
      end
  
      it "determines the correct fields" do
        get  :show, :model => 'users', :id => '1', :fields => 'email'
        assigns[:the_fields].should == ['email']
      end
  
      it "returns the correct json data" do
        get  :show, :model => 'users', :id => '1', :fields => 'email'
        ActiveSupport::JSON.decode(response.body).should == 
        ActiveSupport::JSON.decode({"email"=>"smith@smith.com"}.to_json)
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

    context 'failed operation' do
      before(:each) do
        User.should_receive('find').with(1).and_raise(ActiveRecord::RecordNotFound)
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
  
  describe 'POST /user' do
    
    context 'successful operation' do
      before(:each) do
        @auser = User.new(:name => 'J Smith', :email => 'smith@smith.com')
        User.stub(:new){@auser}
        user.should_receive('save'){true}
      end
      
      it "selects the correct model" do
        post :create, :model => 'users', :name => 'J Smith', :email => 'smith@smith.com'
        assigns[:model].should == 'User'
      end

      it "calls the correct method" do
        User.should_receive(:new).with("name" => "J Smith", 'email' => 'smith@smith.com' ).and_return(user)
        post :create, :model => 'users', :name => 'J Smith', :email => 'smith@smith.com'
      end

      it "returns a success response" do
        post :create, :model => 'users', :name => 'J Smith', :email => 'smith@smith.com'
        ActiveSupport::JSON.decode(response.body).should == 
        ActiveSupport::JSON.decode(
            {"name"=>"J Smith", "email"=>"smith@smith.com"}.to_json)
      end
    end
    
    context 'failed operation' do
      it "returns a fail response" do
        post :create, :model => 'users', :name => 'J Smith'
        ActiveSupport::JSON.decode(response.body).should == 
        ActiveSupport::JSON.decode(
            {"email"=>["can't be blank"]}.to_json)
      end
    end
  end
  
  describe 'handling associations' do
    describe 'single association' do
      before(:each) do
        User.should_receive('find').with(1){user}
        user.stub('recipes'){[recipe, recipe]}
      end

      it 'assigns the correct association names' do
        get :show, :model => 'users', :id => '1', :association => 'recipes'
        assigns[:the_associations].should == ['recipes']
      end
  
      it 'fetches the correct association' do
        user.should_receive('recipes')
        get :show, :model => 'users', :id => '1', :association => 'recipes'
      end
  
      it "returns the correct json data" do
        get :show, :model => 'users', :id => '1', :association => 'recipes'
        ActiveSupport::JSON.decode(response.body).should == 
        ActiveSupport::JSON.decode(
            {"name"=>"J Smith", "email"=>"smith@smith.com",
              "recipes" => [
                {'name' => 'Boiled eggs', 'description' => 'Grab an egg'},
                {'name' => 'Boiled eggs', 'description' => 'Grab an egg'}
              ]
            }.to_json)
      end
    end
    
    describe 'multiple associations' do
      before(:each) do
        User.should_receive('find').with(1){user}
        user.stub('recipes'){[recipe, recipe]}
        user.stub('shops'){[recipe, recipe]}
      end

      it 'assigns the correct association names' do
        get :show, :model => 'users', :id => '1', :association => 'recipes,shops'
        assigns[:the_associations].should == ['recipes', 'shops']
      end
  
      it 'fetches the correct associations' do
        user.should_receive('recipes')
        user.should_receive('shops')
        get :show, :model => 'users', :id => '1', :association => 'recipes,shops'
      end
  
      it "returns the correct json data" do
        get :show, :model => 'users', :id => '1', :association => 'recipes,shops'
        ActiveSupport::JSON.decode(response.body).should == 
        ActiveSupport::JSON.decode(
            {"name"=>"J Smith", "email"=>"smith@smith.com",
              "recipes" => [
                {'name' => 'Boiled eggs', 'description' => 'Grab an egg'},
                {'name' => 'Boiled eggs', 'description' => 'Grab an egg'}
              ],
              "shops" => [
                {'name' => 'Boiled eggs', 'description' => 'Grab an egg'},
                {'name' => 'Boiled eggs', 'description' => 'Grab an egg'}
              ]
            }.to_json)
      end
    end
  end
 
end
