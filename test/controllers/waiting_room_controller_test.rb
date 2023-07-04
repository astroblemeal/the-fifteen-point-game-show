require "test_helper"

class WaitingRoomControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get waiting_room_index_url
    assert_response :success
  end
end
