require 'test_helper'


class NavigationTest < ActiveSupport::IntegrationCase
  test 'Accessing /users returns a list of users' do
    visit user_path
    assert_equal 'javascript/json', headers['Content-Type']
  end
    
protected

  def headers
    page.response_headers
  end
end