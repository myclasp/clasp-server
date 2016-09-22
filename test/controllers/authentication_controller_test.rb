require 'test_helper'

class AuthenticationControllerTest < ActionDispatch::IntegrationTest
  test "authenticates and returns user details" do
    u = User.create({ email: "test@test.com", password: "passwurd" })

    post '/auth_user',
      params: { email: "test@test.com", password: "passwurd" },
      headers: { 'Accept' => Mime[:json], 'Content-Type' => Mime[:json].to_s },
      env: {},
      xhr: false,
      as: :json

    assert_equal true, JSON.parse(response.body)["success"]
    assert_equal "application/json", response.content_type
  end

  test "fails authentication" do
    u = User.create({ email: "test@test.com", password: "passwurd" })

    post '/auth_user',
      params: { email: "test@test.com", password: "wrongpasswurd" },
      headers: { 'Accept' => Mime[:json], 'Content-Type' => Mime[:json].to_s },
      env: {},
      xhr: false,
      as: :json
    
    assert_response(:unauthorized)
    assert_equal false, JSON.parse(response.body)["success"]
    assert_equal "application/json", response.content_type
  end
end
