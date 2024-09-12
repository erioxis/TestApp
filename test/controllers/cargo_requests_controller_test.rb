require "test_helper"

class CargoRequestsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get cargo_requests_new_url
    assert_response :success
  end

  test "should get create" do
    get cargo_requests_create_url
    assert_response :success
  end

  test "should get show" do
    get cargo_requests_show_url
    assert_response :success
  end
end
