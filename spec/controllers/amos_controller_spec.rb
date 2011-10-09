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

    it "routes /user/query to the query action" do
      { :get => "/user/find/by_name" }.
        should route_to(:controller => "amos", :action => "find", :model => 'user', :query => 'by_name')
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
        setAbilityAuthorized
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
    
    
    context 'failed authorization' do
      before(:each) do
        setAbilityUnauthorized
       end
       
       it "returns a 401 error code" do
         get :index, :model => 'user'
         response.status.should == 401 
       end
       
      it "returns the correct json data" do
        get :index, :model => 'user'
        ActiveSupport::JSON.decode(response.body).should == 
        ActiveSupport::JSON.decode({"error" => "You are not authorized to access this data"}.to_json)
      end
    end
  end

  describe 'GET /user/find' do

    context 'successful operation : single term' do
      before(:each) do
        setAbilityAuthorized
        User.stub('find_all_by_name').with('J Smith'){[user]}
       end
       
      it "selects the correct model" do
        get :find, :model => 'user', :query => 'by_name', :term => 'J Smith'
        assigns[:model].should == 'User'
      end

      it "calls the correct method with no field filter" do
        User.should_receive('find_all_by_name').with('J Smith'){[user]}
        get :find, :model => 'user', :query => 'by_name',:term => 'J Smith'
      end
  
      it "returns the correct json data with no field filter" do
        get :find, :model => 'user', :query =>'by_name',:term => 'J Smith'
        ActiveSupport::JSON.decode(response.body).should == 
        ActiveSupport::JSON.decode([
            {"name" => "J Smith", "email"=>"smith@smith.com"}
        ].to_json)
      end
      
      it "determines the correct fields with field filter" do
        get :find, :model => 'user', :query =>'by_name',:term => 'J Smith', :fields => 'email'
        assigns[:the_fields].should == ['email']
      end
  
      it "returns the correct json data with field filter" do
        get :find, :model => 'user', :query =>'by_name',:term => 'J Smith', :fields => 'email'
        ActiveSupport::JSON.decode(response.body).should == 
        ActiveSupport::JSON.decode([
          {"email"=>"smith@smith.com"}
        ].to_json)
      end
      
    end
    
    context 'successful operation : multiple terms' do
      before(:each) do
        setAbilityAuthorized
        User.stub('find_all_by_name_and_email').with('J Smith', 'smith@smith.com'){[user]}
       end
       
      it "calls the correct method with no field filter" do
        User.should_receive('find_all_by_name_and_email').with('J Smith', 'smith@smith.com'){[user]}
        get :find, :model => 'user', :query => 'by_name_and_email',:term => 'J Smith,smith@smith.com'
      end
  
      it "returns the correct json data with no field filter" do
        get :find, :model => 'user', :query => 'by_name_and_email',:term => 'J Smith,smith@smith.com'
        ActiveSupport::JSON.decode(response.body).should == 
        ActiveSupport::JSON.decode([
            {"name" => "J Smith", "email"=>"smith@smith.com"}
        ].to_json)
      end
    end
    
    
    context 'failed authorization' do
      before(:each) do
        setAbilityUnauthorized
       end
       
       it "returns a 401 error code" do
         get :find, :model => 'user', :query =>'by_name',:term => 'J Smith'
         response.status.should == 401 
       end
       
      it "returns the correct json data" do
        get :find, :model => 'user', :query =>'by_name',:term => 'J Smith'
        ActiveSupport::JSON.decode(response.body).should == 
        ActiveSupport::JSON.decode({"error" => "You are not authorized to access this data"}.to_json)
      end
    end
  end

 
  describe 'GET /user?fields=' do

    context 'successful operation' do
      before(:each) do
        setAbilityAuthorized
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
        setAbilityAuthorized
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
 
    context 'failed operation' do
      before(:each) do
        setAbilityAuthorized
        User.should_receive('find').with(1).and_raise(ActiveRecord::RecordNotFound)
      end

      it "returns the correct json data" do
        get :show, :model => 'users', :id => '1'
        ActiveSupport::JSON.decode(response.body).should == 
        ActiveSupport::JSON.decode(
            {"error"=>"Record 1 not found"}.to_json)
      end
      
      it "returns a 400 error code" do
        get :show, :model => 'users', :id => '1'
        response.status.should == 400 
      end
    end 
  end

  describe 'GET /user/:id?fields=' do

    context 'successful operation' do
      before(:each) do
        setAbilityAuthorized
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
        setAbilityAuthorized
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
        setAbilityAuthorized
        User.should_receive('find').with(1).and_raise(ActiveRecord::RecordNotFound)
       end
      it "returns a fail response" do
         delete :destroy, :model => 'users', :id => '1'
        ActiveSupport::JSON.decode(response.body).should == 
        ActiveSupport::JSON.decode(
            {"error"=>"Record 1 not found"}.to_json)
      end

      it "returns a 400 error code" do
         delete :destroy, :model => 'users', :id => '1'
        response.status.should == 400 
      end
    end

    context 'failed authorization' do
      before(:each) do
        setAbilityUnauthorizedUser
        User.stub('find').with(1){user}
       end
       
       it "returns a 401 error code" do
         delete :destroy, :model => 'users', :id => '1'
         response.status.should == 401 
       end
       
      it "returns the correct json data" do
        delete :destroy, :model => 'users', :id => '1'
        ActiveSupport::JSON.decode(response.body).should == 
        ActiveSupport::JSON.decode({"error" => "You are not authorized to access this data"}.to_json)
      end
    end
    
  end

  describe 'PUT /user/:id' do
    context 'successful operation' do
      before(:each) do
        setAbilityAuthorized
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
            {'name' => 'fred', 'email' => 'smith'}.to_json)
      end
    end
    
    context 'failed operation' do
      before(:each) do
        setAbilityAuthorized
        User.should_receive('find').with(1){user}
        user.should_receive('update_attributes').with('name' => 'fred', 'email' => ''){false}
        user.should_receive('errors'){{:email => ["can't be blank"]}}
      end
      
      it "returns a fail response" do
        put :update, :model => 'users', :id => '1', :name => 'fred', :email => ''
        ActiveSupport::JSON.decode(response.body).should == 
        ActiveSupport::JSON.decode(
            {"email"=>["can't be blank"]}.to_json)
      end

      it "returns a 400 error code" do
        put :update, :model => 'users', :id => '1', :name => 'fred', :email => ''
        response.status.should == 400 
      end

    end
    context 'failed authorization' do
      before(:each) do
        setAbilityUnauthorizedUser
        User.stub('find').with(1){user}
       end
       
       it "returns a 401 error code" do
         put :update, :model => 'users', :id => '1', :name => 'fred', :email => ''
         response.status.should == 401 
       end
       
      it "returns the correct json data" do
        put :update, :model => 'users', :id => '1', :name => 'fred', :email => ''
        ActiveSupport::JSON.decode(response.body).should == 
        ActiveSupport::JSON.decode({"error" => "You are not authorized to access this data"}.to_json)
      end
    end
  end
  
  describe 'POST /user' do
    
    context 'successful operation' do
      before(:each) do
        setAbilityAuthorized
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

      it "returns a 400 error code" do
        post :create, :model => 'users', :name => 'J Smith'
        response.status.should == 400 
      end

    end
    
    context 'failed authorization' do
      before(:each) do
        setAbilityUnauthorizedUser
        User.stub('find').with(1){user}
       end
       
       it "returns a 401 error code" do
         post :create, :model => 'users', :name => 'J Smith'
         response.status.should == 401 
       end
       
      it "returns the correct json data" do
        post :create, :model => 'users', :name => 'J Smith'
        ActiveSupport::JSON.decode(response.body).should == 
        ActiveSupport::JSON.decode({"error" => "You are not authorized to access this data"}.to_json)
      end
    end
    
  end
  
  describe 'handling associations' do
    describe 'single association' do
      before(:each) do
        setAbilityAuthorized
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
        setAbilityAuthorized
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
  
    describe 'GET /user with pagination' do

      context 'successful operation' do
        before(:each) do
          setAbilityAuthorized
          User.paginate_results
          User.stub('paginate'){[user,user,user]}
         end

        it "calls the correct method" do
          User.should_receive('paginate').with(:page => 2, :per_page => 30){[user]}
          get :index, :model => 'user', :page => 2
        end

        it "sets paginate flag" do
          get :index, :model => 'user', :page => 2
          assigns[:paginate_flag].should == true
        end

        it "returns the correct json data" do
          get :index, :model => 'user'
          ActiveSupport::JSON.decode(response.body).should == 
          ActiveSupport::JSON.decode([
            {"name" => "J Smith", "email"=>"smith@smith.com"},
            {"name" => "J Smith", "email"=>"smith@smith.com"},
            {"name" => "J Smith", "email"=>"smith@smith.com"}
          ].to_json)
        end
      end

    end

    describe 'GET /user/find with pagination' do

      context 'successful operation : single term' do
        before(:each) do
          setAbilityAuthorized
          User.paginate_results
          result = []
          User.stub('scoped_by_name').with('J Smith'){result}
          result.stub('paginate'){[user, user, user]}
         end

        it "calls the correct method with no field filter" do
          result = [user, user, user]
          User.should_receive('scoped_by_name').with('J Smith'){result}
          result.should_receive('paginate'){[user, user, user]}
          get :find, :model => 'user', :query => 'by_name',:term => 'J Smith'
        end

        it "returns the correct json data with no field filter" do
          get :find, :model => 'user', :query =>'by_name',:term => "J Smith"
          ActiveSupport::JSON.decode(response.body).should == 
          ActiveSupport::JSON.decode([
            {"name" => "J Smith", "email"=>"smith@smith.com"},
            {"name" => "J Smith", "email"=>"smith@smith.com"},
            {"name" => "J Smith", "email"=>"smith@smith.com"}
          ].to_json)
        end

        it "determines the correct fields with field filter" do
          get :find, :model => 'user', :query =>'by_name',:term => 'J Smith', :fields => 'email'
          assigns[:the_fields].should == ['email']
        end

        it "returns the correct json data with field filter" do
          get :find, :model => 'user', :query =>'by_name',:term => 'J Smith', :fields => 'email'
          ActiveSupport::JSON.decode(response.body).should == 
          ActiveSupport::JSON.decode([
            {"email"=>"smith@smith.com"},
            {"email"=>"smith@smith.com"},
            {"email"=>"smith@smith.com"}
          ].to_json)
        end

      end

    end
    
  end
  

  def setAbilityAuthorized
    eval <<-eos
  	class Ability
  	  include CanCan::Ability

  	  def initialize(user)
  	    can :manage, :all
  	  end
  	end

    class ApplicationController < ActionController::Base
      def current_user
        nil
      end
    end

    eos

  end 

  def setAbilityUnauthorized
    eval <<-eos
  	class Ability
  	  include CanCan::Ability

  	  def initialize(user)
  	    cannot :manage, :all
  	  end
  	end

    class ApplicationController < ActionController::Base
      def current_user
        nil
      end
    end

    eos

  end 

  def setAbilityUnauthorizedUser
    eval <<-eos
  	class Ability
  	  include CanCan::Ability

  	  def initialize(user)
  	    can :read, User
  	    cannot :delete, User
  	    cannot :update, User
  	    cannot :create, User
  	  end
  	end

    class ApplicationController < ActionController::Base
      def current_user
        nil
      end
    end

    eos

  end 

end
