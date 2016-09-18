require 'test_helper'

class MomentsControllerTest < ActionDispatch::IntegrationTest
  
  test "should create moments" do
    new_moments = [{ timestamp: Time.now, state: 'up', latitude: 12.00, longitude: -12.00 }]
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

end
