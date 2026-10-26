require "test_helper"

class EmployeesControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    sign_in users(:one)
  end

  test "should get index" do
    get employees_url
    assert_response :success
  end

  test "should get show" do
    get employee_url(employees(:one))
    assert_response :success
  end

  test "should get new" do
    get new_employee_url
    assert_response :success
  end

  test "should get edit" do
    get edit_employee_url(employees(:one))
    assert_response :success
  end

  test "should create an employee" do
    assert_difference("Employee.count", 1) do
      post employees_url, params: {
        employee: {
          name: "Avery Chen",
          email: "avery.chen@example.test",
          phone: "555-0101",
          department_id: departments(:engineering).id,
          salary: 85_000,
          joining_date: "2025-02-01",
          manager_id: employees(:one).id,
          active: "true"
        }
      }
    end

    assert_redirected_to employee_url(Employee.order(:created_at).last)
  end

  test "should render the new form when employee is invalid" do
    assert_no_difference("Employee.count") do
      post employees_url, params: { employee: { name: "", email: "invalid" } }
    end

    assert_response :unprocessable_entity
    assert_select ".alert-danger"
  end

  test "should update an employee" do
    employee = employees(:one)

    patch employee_url(employee), params: {
      employee: { name: "Updated Employee" }
    }

    assert_redirected_to employee_url(employee)
    assert_equal "Updated Employee", employee.reload.name
  end

  test "should delete an employee" do
    employee = employees(:two)

    assert_difference("Employee.count", -1) do
      delete employee_url(employee)
    end

    assert_redirected_to employees_url
  end

  test "should show an employee's subordinates" do
    get subordinates_employee_url(employees(:one))

    assert_response :success
    assert_select "h1", text: employees(:one).name
    assert_select "td", text: employees(:two).name
  end

  test "should search employees by name, email, manager, department, or employee ID" do
    [
      "Riley",
      "riley.patel@example.test",
      "Morgan",
      "morgan.lee@example.test",
      "Engineering",
      employees(:two).id.to_s
    ].each do |query|
      get employees_url, params: { q: query }

      assert_response :success
      assert_select "td", text: employees(:two).name
    end
  end

  test "should filter employees by status, department, manager, and joining date range" do
    get employees_url, params: {
      status: "inactive",
      department_id: departments(:engineering).id,
      manager_id: employees(:one).id,
      joined_from: "2024-01-01",
      joined_to: "2024-12-31"
    }

    assert_response :success
    assert_select "tbody tr", count: 1
    assert_select "td", text: employees(:two).name
  end

  test "should show manager-wise team listing" do
    get teams_url

    assert_response :success
    assert_select "h2", text: employees(:one).name
    assert_select "td", text: employees(:two).name
  end
end
