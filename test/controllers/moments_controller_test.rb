require 'test_helper'

class MomentsControllerTest < ActionDispatch::IntegrationTest
  
  test "should create moments" do
    new_moments = [{ identifier:1, timestamp: Time.now, state: 0, latitude: 12.00, longitude: -12.00 }]
    expected = Moment.count+new_moments.size

    post '/moments',
      params: { moments: new_moments.to_json },
      headers: { 'Accept' => Mime[:json], 'Content-Type' => Mime[:json].to_s },
      env: {},
      xhr: false,
      as: :json

    assert_response :success
    assert_equal "application/json", response.content_type
    assert_equal expected, Moment.count
  end

  test "should respond with 400 error for format" do
    post '/moments',
      params: { moments: { timestamp: Time.now }.to_json },
      headers: { 'Accept' => Mime[:json], 'Content-Type' => Mime[:json].to_s },
      env: {},
      xhr: false,
      as: :json

    assert_response(400)
    assert_equal false, JSON.parse(response.body)["success"]
    assert_equal "application/json", response.content_type
  end

  test "should respond with 400 error for missing identifier" do
    post '/moments',
      params: { moments: [{ timestamp: Time.now }].to_json },
      headers: { 'Accept' => Mime[:json], 'Content-Type' => Mime[:json].to_s },
      env: {},
      xhr: false,
      as: :json

    assert_response(400)
    assert_equal false, JSON.parse(response.body)["success"]
    assert_equal "application/json", response.content_type
  end

end
