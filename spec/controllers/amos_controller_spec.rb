require File.expand_path(File.dirname(__FILE__) + '/../../test/spec_helper')


describe Amos::AmosController do

  let(:user) {User.new(:email => 'smith@smith.com', :name => 'J Smith')}

  describe '/user' do

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
        {"user"=>
          {"name"=>"J Smith", "created_at"=>nil, "updated_at"=>nil, "email"=>"smith@smith.com"}
        }
      ].to_json)
    end
  end
  
  describe '/user/:id' do
    it "selects the correct model" do
      User.should_receive('find').with(1){user}
      get :with_id, :model => 'user', :id => '1'
      assigns[:model].should == 'User'
    end

    it "calls the correct method" do
      User.should_receive('find').with(1){user}
      get :with_id, :model => 'user', :id => '1'
    end

    it "returns the correct json data" do
      User.should_receive('find').with(1){user}
      get :with_id, :model => 'user', :id => '1'
      ActiveSupport::JSON.decode(response.body).should == 
      ActiveSupport::JSON.decode(
        {"user"=>
          {"name"=>"J Smith", "created_at"=>nil, "updated_at"=>nil, "email"=>"smith@smith.com"}
        }.to_json)
    end
  end
  
end
