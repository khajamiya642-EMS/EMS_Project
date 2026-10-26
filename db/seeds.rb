# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
# db/seeds.rb

# db/seeds.rb

Employee.destroy_all

Employee.create!(
  name: "Alice Johnson",
  email: "alice@example.com",
  phone: "1234567890",
  department: "HR",
  salary: "50000",
  manager_id: nil
)

Employee.create!(
  name: "Bob Smith",
  email: "bob@example.com",
  phone: "9876543210",
  department: "IT",
  salary: "60000",
  manager_id: 1
)

Employee.create!(
  name: "Charlie Brown",
  email: "charlie@example.com",
  phone: "5555555555",
  department: "Finance",
  salary: "55000",
  manager_id: 1
)

Employee.create!(
  name: "Diana Prince",
  email: "diana@example.com",
  phone: "4444444444",
  department: "Marketing",
  salary: "48000",
  manager_id: 2
)

Employee.create!(
  name: "Ethan Hunt",
  email: "ethan@example.com",
  phone: "3333333333",
  department: "Operations",
  salary: "52000",
  manager_id: 2
)

puts "Seeded #{Employee.count} employees."
