require 'test_helper'

class MomentsControllerTest < ActionDispatch::IntegrationTest
  
  def setup
    @user = User.create({ email: "test@test.com", password: "passwurd" }) 
  end

  test "should create moments" do
    new_moments = [{ identifier:1, timestamp: Time.now, state: 0, latitude: 12.00, longitude: -12.00 }]
    expected = Moment.count+new_moments.size

    post '/v1/moments',
      params: { user_id: @user.uuid, moments: new_moments },
      headers: { 'Accept' => Mime[:json], 'Content-Type' => Mime[:json].to_s },
      env: {},
      xhr: false,
      as: :json

    assert_response :success
    assert_equal "application/json", response.content_type
    assert_equal expected, Moment.count
  end

  test "should respond with 400 error for format" do
    post '/v1/moments',
      params: { user_id: @user.uuid, moments: { timestamp: Time.now }.to_json },
      headers: { 'Accept' => Mime[:json], 'Content-Type' => Mime[:json].to_s },
      env: {},
      xhr: false,
      as: :json

    assert_response(400)
    assert_equal false, JSON.parse(response.body)["success"]
    assert_equal "application/json", response.content_type
  end

  test "should respond with 400 error for missing identifier" do
    post '/v1/moments',
      params: { user_id: @user.uuid, moments: [{ timestamp: Time.now }].to_json },
      headers: { 'Accept' => Mime[:json], 'Content-Type' => Mime[:json].to_s },
      env: {},
      xhr: false,
      as: :json

    assert_response(400)
    assert_equal false, JSON.parse(response.body)["success"]
    assert_equal "application/json", response.content_type
  end

end
