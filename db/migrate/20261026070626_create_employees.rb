class CreateEmployees < ActiveRecord::Migration[8.1]
  def change
    create_table :employees do |t|
      t.string :name
      t.string :email
      t.string :phone
      t.string :department
      t.integer :salary
      t.integer :manager_id

      t.timestamps
    end
  end
end
