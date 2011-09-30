require File.expand_path(File.dirname(__FILE__) + '/../../test/spec_helper')


describe Amos::AmosController do

  let(:user) {User.new(:email => 'smith@smith.com', :name => 'J Smith')}

  describe 'GET /user' do

    it "should route to amos controller#all" do
      assert_recognizes({ :controller => "amos/amos", :action => "index", :model => 'user'}, "/user")
    end
    
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
    it "should route to amos controller#with_id" do
      assert_recognizes({ :controller => "amos/amos", :action => "show", :model => 'user', :id => '1'}, "/user/1")
    end

    context 'successful operation' do
      before(:each) do
        User.should_receive('find').with(1){user}
      end

      it "selects the correct model" do
        get :show, :model => 'user', :id => '1'
        assigns[:model].should == 'User'
      end

      it "calls the correct method" do
        get :show, :model => 'user', :id => '1'
      end

      it "returns the correct json data" do
        get :show, :model => 'user', :id => '1'
        ActiveSupport::JSON.decode(response.body).should == 
        ActiveSupport::JSON.decode(
            {"name"=>"J Smith", "email"=>"smith@smith.com"}.to_json)
      end
    end
  end
  
  describe 'DELETE /user/:id' do
    it "should route to amos controller#with_id" do
      assert_recognizes({ :controller => "amos/amos", :action => "destroy", :model => 'user', :id => '1'}, {:path => 'user/1', :method => :delete})
    end

    context 'successful operation' do
      before(:each) do
        User.should_receive('find').with(1){user}
        user.should_receive('destroy')
      end

      it "selects the correct model" do
        delete :destroy, :model => 'user', :id => '1'
        assigns[:model].should == 'User'
      end

      it "calls the correct method" do
        delete :destroy, :model => 'user', :id => '1'
      end

      it "returns a success response" do
        delete :destroy, :model => 'user', :id => '1'
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
         delete :destroy, :model => 'user', :id => '1'
        ActiveSupport::JSON.decode(response.body).should == 
        ActiveSupport::JSON.decode(
            {"success"=>"false"}.to_json)
      end
    end
  end

  describe 'PUT /user/:id' do
    it "should route to amos controller#with_id" do
      assert_recognizes({ :controller => "amos/amos", :action => "update", :model => 'user', :id => '1'}, {:path => 'user/1', :method => :put})
    end

    context 'successful operation' do
      before(:each) do
        User.should_receive('find').with(1){user}
        user.should_receive('update_attributes').with('name' => 'fred', 'email' => 'smith'){true}
      end
      
      it "selects the correct model" do
        put :update, :model => 'user', :id => '1', :name => 'fred', :email => 'smith'
        assigns[:model].should == 'User'
      end

      it "calls the correct method" do
        put :update, :model => 'user', :id => '1', :name => 'fred', :email => 'smith'
      end

      it "returns a success response" do
        put :update, :model => 'user', :id => '1', :name => 'fred', :email => 'smith'
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
        put :update, :model => 'user', :id => '1', :name => 'fred', :email => 'smith'
        ActiveSupport::JSON.decode(response.body).should == 
        ActiveSupport::JSON.decode(
            {"success"=>"false"}.to_json)
      end
    end
  end
  
  
end
