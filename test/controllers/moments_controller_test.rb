require 'test_helper'

class MomentsControllerTest < ActionDispatch::IntegrationTest

  test "should create moments" do
    new_moments = [{ identifier:1, timestamp: Time.now, state: 0, latitude: 12.00, longitude: -12.00 }]
    expected = Moment.count+new_moments.size

    post "/v1/users/#{User.first.uuid}/moments",
      params: { user_id: User.first.uuid, moments: new_moments },
      headers: { 'Accept' => Mime[:json], 'Content-Type' => Mime[:json].to_s },
      env: {},
      xhr: false,
      as: :json

    assert_response :success
    assert_equal "application/json", response.content_type
    assert_equal expected, Moment.count
  end

  test "should respond with 400 error for format" do
    post "/v1/users/#{User.first.uuid}/moments",
      params: { user_id: User.first.uuid, moments: { timestamp: Time.now }.to_json },
      headers: { 'Accept' => Mime[:json], 'Content-Type' => Mime[:json].to_s },
      env: {},
      xhr: false,
      as: :json

    assert_response(400)
    assert_equal false, JSON.parse(response.body)["success"]
    assert_equal "application/json", response.content_type
  end

  test "should respond with 400 error for missing identifier" do
    post "/v1/users/#{User.first.uuid}/moments",
      params: { user_id: User.first.uuid, moments: [{ timestamp: Time.now }].to_json },
      headers: { 'Accept' => Mime[:json], 'Content-Type' => Mime[:json].to_s },
      env: {},
      xhr: false,
      as: :json

    assert_response(400)
    assert_equal false, JSON.parse(response.body)["success"]
    assert_equal "application/json", response.content_type
  end

  test "should respond with a collection of moments" do
    get "/v1/users/#{User.first.uuid}/moments",
      params: {},
      headers: { 'Accept' => Mime[:json], 'Content-Type' => Mime[:json].to_s },
      xhr: false,
      as: :json

    result = JSON.parse(response.body)

    assert_response(200)
    assert_equal true, result["success"]
    assert_equal true, (result["moments"].size > 0)
  end

  test "should respond with moments created before a set time" do
    count  = User.first.moments.count-1
    toTime = User.first.moments.last.timestamp.to_i-1

    get "/v1/users/#{User.first.uuid}/moments?to=#{toTime}",
      params: {},
      headers: { 'Accept' => Mime[:json], 'Content-Type' => Mime[:json].to_s },
      xhr: false

    result = JSON.parse(response.body)
    assert_response(200)
    assert_equal true, result["success"]
    assert_equal count, result["moments"].size
  end

end
