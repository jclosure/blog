require 'test_helper'

class DnsControllerTest < ActionController::TestCase
  test "should get available" do
    get :available
    assert_response :success
  end

end
