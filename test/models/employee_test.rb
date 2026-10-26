require "test_helper"

class EmployeeTest < ActiveSupport::TestCase
  test "is valid with all required employee details" do
    employee = Employee.new(
      name: "Avery Chen",
      email: "avery.chen@example.test",
      phone: "555-0101",
      department: departments(:engineering),
      salary: 85_000
    )

    assert employee.valid?
  end

  test "rejects invalid emails and negative salaries" do
    employee = employees(:one)
    employee.email = "not-an-email"
    employee.salary = -1

    assert_not employee.valid?
    assert_includes employee.errors[:email], "is invalid"
    assert_includes employee.errors[:salary], "must be greater than or equal to 0"
  end

  test "cannot report to itself" do
    employee = employees(:one)
    employee.update_column(:manager_id, nil)
    employee.manager_id = employee.id

    assert_not employee.valid?
    assert_includes employee.errors[:manager], "can't be the employee"
  end

  test "clears subordinate manager references when a manager is deleted" do
    manager = employees(:one)
    subordinate = employees(:two)

    manager.destroy

    assert_nil subordinate.reload.manager_id
  end

  test "defaults new employees to active and today's joining date" do
    employee = Employee.new(
      name: "Avery Chen",
      email: "avery.chen@example.test",
      phone: "555-0101",
      department: departments(:engineering),
      salary: 85_000
    )

    assert employee.valid?
    assert employee.active?
    assert_equal Date.current, employee.joining_date
  end
end
