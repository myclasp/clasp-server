require 'test_helper'

class SignupControllerTest < ActionDispatch::IntegrationTest
  test "creates user and returns user details" do
    post '/v1/users',
      params: { user: { email: "test@test.com", password: "passwurd", password_confirmation: "passwurd" } },
      headers: { 'Accept' => Mime[:json], 'Content-Type' => Mime[:json].to_s },
      env: {},
      xhr: false,
      as: :json

    result = JSON.parse(response.body)
    assert_equal true, result["success"]
    assert_equal true, result.has_key?("email")
    assert_equal true, result.has_key?("id")
    assert_equal "application/json", response.content_type
  end

  test "fails user creation and returns errors" do
    post '/v1/users',
      params: { user: { email: "test@test.com", password: "password" } },
      headers: { 'Accept' => Mime[:json], 'Content-Type' => Mime[:json].to_s },
      env: {},
      xhr: false,
      as: :json

    result = JSON.parse(response.body)
    assert_equal false, result["success"]
    assert_equal true, result.has_key?("errors")
    
    assert_equal "application/json", response.content_type
  end
end
