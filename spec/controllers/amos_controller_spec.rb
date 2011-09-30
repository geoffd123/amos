require File.expand_path(File.dirname(__FILE__) + '/../../test/spec_helper')


describe Amos::AmosController do
  let(:user) {mock}

  it "selects the correct model" do
    get :access, :model => 'user', :method => 'findAll'
    assigns[:model].should == 'User'
  end

  it "calls the correct method" do
    get :access, :model => 'user', :method => 'findAll'
    user.should_receive(:findAll)
  end

end
