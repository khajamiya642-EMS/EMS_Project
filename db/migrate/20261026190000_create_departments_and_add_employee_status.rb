class CreateDepartmentsAndAddEmployeeStatus < ActiveRecord::Migration[8.1]
  def up
    create_table :departments do |t|
      t.string :name, null: false
      t.timestamps
    end
    add_index :departments, :name, unique: true

    add_reference :employees, :department, foreign_key: true
    add_column :employees, :active, :boolean, default: true, null: false
    add_column :employees, :joining_date, :date

    execute <<~SQL
      UPDATE employees
      SET joining_date = DATE(created_at)
      WHERE joining_date IS NULL
    SQL

    select_values("SELECT DISTINCT department FROM employees").each do |name|
      normalized_name = name.to_s.strip.presence || "Unassigned"
      department_id = select_value(
        "SELECT id FROM departments WHERE LOWER(name) = LOWER(#{connection.quote(normalized_name)})"
      )
      unless department_id
        execute(
          "INSERT INTO departments (name, created_at, updated_at) VALUES (#{connection.quote(normalized_name)}, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)"
        )
        department_id = select_value(
          "SELECT id FROM departments WHERE LOWER(name) = LOWER(#{connection.quote(normalized_name)})"
        )
      end
      execute(
        "UPDATE employees SET department_id = #{connection.quote(department_id)} " \
        "WHERE department = #{connection.quote(name)} " \
        "OR ((department IS NULL OR TRIM(department) = '') AND #{connection.quote(normalized_name)} = 'Unassigned')"
      )
    end

    change_column_null :employees, :department_id, false
    change_column_null :employees, :joining_date, false
    remove_column :employees, :department, :string
  end

  def down
    add_column :employees, :department, :string
    execute <<~SQL
      UPDATE employees
      SET department = (
        SELECT departments.name
        FROM departments
        WHERE departments.id = employees.department_id
      )
    SQL
    remove_reference :employees, :department, foreign_key: true
    remove_column :employees, :active, :boolean
    remove_column :employees, :joining_date, :date
    drop_table :departments
  end
end
