require File.expand_path(File.dirname(__FILE__) + '/../../test/spec_helper')

class User
end

describe Amos::AmosController do
  let(:user) {mock}
  it "selects the correct model" do
    get "/user/findAll"
    assigns[:theModel].should be('User')
  end

  it "selects the correct method" do
    get "/user/findAll"
    assigns[:theMethod].should be('findAll')
  end

  it "calls the correct method" do
    get "/user/findAll"
    user.should_receive(:findAll)
  end

end
