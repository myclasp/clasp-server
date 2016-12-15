require 'test_helper'

class AdminControllerTest < ActionDispatch::IntegrationTest
  test "should redirect when not signed in"
    get admin_url
    assert_response :redirect
  end

end
