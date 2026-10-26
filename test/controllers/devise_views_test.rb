require "test_helper"

class DeviseViewsTest < ActionDispatch::IntegrationTest
  test "authentication pages render with Bootstrap form controls" do
    [
      new_user_session_url,
      new_user_registration_url,
      new_user_password_url
    ].each do |path|
      get path

      assert_response :success
      assert_select ".card"
      assert_select "input.form-control"
    end
  end
end
