require "test_helper"

class CsvControllerTest < ActionDispatch::IntegrationTest
  test "should get upload" do
    get csv_upload_url
    assert_response :success
  end
end
