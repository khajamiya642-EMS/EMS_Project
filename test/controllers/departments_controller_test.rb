require "test_helper"

class DepartmentsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    sign_in users(:one)
  end

  test "lists departments with employee counts" do
    get departments_url

    assert_response :success
    assert_select "td", text: "Operations"
    assert_select "td", text: "1"
  end

  test "creates a department" do
    assert_difference("Department.count", 1) do
      post departments_url, params: { department: { name: "Finance" } }
    end

    assert_redirected_to department_url(Department.order(:created_at).last)
  end

  test "updates a department" do
    patch department_url(departments(:operations)), params: {
      department: { name: "Operations and Support" }
    }

    assert_redirected_to department_url(departments(:operations))
    assert_equal "Operations and Support", departments(:operations).reload.name
  end

  test "shows employees assigned to a department" do
    get department_url(departments(:engineering))

    assert_response :success
    assert_select "td", text: employees(:two).name
  end

  test "does not delete a department that has employees" do
    assert_no_difference("Department.count") do
      delete department_url(departments(:operations))
    end

    assert_redirected_to department_url(departments(:operations))
  end

  test "deletes an empty department" do
    department = Department.create!(name: "Temporary")

    assert_difference("Department.count", -1) do
      delete department_url(department)
    end

    assert_redirected_to departments_url
  end
end
