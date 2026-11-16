# Employee Manager

Employee Manager is a Rails 8 application for maintaining an employee directory.
Signed-in users can manage employees and departments, assign employees to
departments and managers, browse teams, and search and filter the directory.
The interface uses Bootstrap 5, Devise provides authentication, and SQLite is
the default database.

## Contents

- [Requirements](#requirements)
- [Setup](#setup)
- [Using the application](#using-the-application)
- [Employee search and filters](#employee-search-and-filters)
- [Data model and rules](#data-model-and-rules)
- [Routes](#routes)
- [Database and migrations](#database-and-migrations)
- [Tests and code quality](#tests-and-code-quality)
- [Project structure](#project-structure)
- [Troubleshooting](#troubleshooting)

## Requirements

- Ruby version specified in `.ruby-version`
- Bundler
- SQLite 3
- A JavaScript-capable browser

Rails and the other Ruby dependencies are specified in `Gemfile` and
`Gemfile.lock`. Bootstrap is compiled from Sass through `dartsass-rails`.

## Setup

Run these commands from the project root:

```sh
bundle install
bin/rails db:prepare
bin/rails server
```

Open [http://localhost:3000](http://localhost:3000). Create an account at
`/users/sign_up`, then sign in. The employee and department pages require an
authenticated user. Registration is enabled by Devise; this project does not
currently implement role-based authorization.

To stop the development server, press `Ctrl+C` in the terminal running it.

## Using the application

### Departments

1. Open `/departments`.
2. Choose **Add department** and enter a unique department name.
3. Open a department to see its employees and total employee count.
4. Choose **Assign employee** to create an employee with that department
   preselected.

Department names are trimmed before saving, and blank or duplicate names are
rejected. A department that still has employees cannot be deleted. Move or
delete those employees before deleting the department.

### Employees

1. Open `/employees` and choose **Add employee**.
2. Enter the employee's name, email, phone, salary, department, and joining
   date. Manager is optional. New employees default to Active.
3. Open an employee row to view its details and direct reports.
4. Use **Edit** to update the record. Use **Delete** to remove it after
   confirming the action.

Employee IDs shown in the list and detail page are the database-generated
integer IDs. They are searchable but are not separately assigned employee
numbers.

### Teams

Open `/teams` or choose **Teams by manager** from the employee directory. The
page groups employees under each manager and lists employees without a manager
in a separate section. Teams are based on direct manager/report relationships;
the view does not expand nested reporting hierarchies.

## Employee search and filters

The directory search accepts a substring in any of these fields:

- Employee name
- Employee database ID (exact numeric ID)
- Employee email
- Department name
- Manager name or email

Search can be combined with the following filters:

| Filter | Query parameter | Accepted value |
| --- | --- | --- |
| Employment status | `status` | `active` or `inactive` |
| Department | `department_id` | Department database ID |
| Manager | `manager_id` | Manager's employee database ID |
| Joining date start | `joined_from` | Date in `YYYY-MM-DD` format |
| Joining date end | `joined_to` | Date in `YYYY-MM-DD` format |

The date bounds are inclusive. For example, this URL searches for an employee,
department, or manager matching “alex”, and limits results to active employees
in department 2 who joined during 2024:

```text
/employees?q=alex&status=active&department_id=2&joined_from=2024-01-01&joined_to=2024-12-31
```

The manager filter can be added with `&manager_id=5`. Leave filters blank or
choose **Clear filters** to return to the complete directory.

## Data model and rules

### Employee

An employee belongs to one department and can optionally report to another
employee. An employee can also have multiple direct reports.

| Field | Description |
| --- | --- |
| `id` | Database-generated employee ID |
| `name` | Required employee name |
| `email` | Required, valid, unique email address |
| `phone` | Required phone number |
| `salary` | Required non-negative integer |
| `department_id` | Required department association |
| `manager_id` | Optional reference to the employee's manager |
| `active` | Boolean employment status; new employees default to `true` |
| `joining_date` | Required date; defaults to the current date for new records |

An employee cannot be their own manager. Deleting a manager preserves their
direct reports and clears those employees' manager assignments.

### Department

A department has a unique name and can have many employees. Its displayed
employee count includes both active and inactive employees. Deleting a
department with employees is restricted to prevent employees from losing their
required department assignment.

### User

Devise manages user registration, sign-in, sign-out, password recovery, and
account editing. Employee and department controller actions require a signed-in
user.

## Routes

All employee and department routes below are HTML pages or form submissions.
They require authentication unless stated otherwise.

### Employees

| Method | Path | Purpose |
| --- | --- | --- |
| `GET` | `/` | Employee directory |
| `GET` | `/employees` | Employee directory with search and filters |
| `GET` | `/employees/new` | New employee form |
| `POST` | `/employees` | Create employee |
| `GET` | `/employees/:id` | Employee details and direct reports |
| `GET` | `/employees/:id/edit` | Edit employee form |
| `PATCH` / `PUT` | `/employees/:id` | Update employee |
| `DELETE` | `/employees/:id` | Delete employee |
| `GET` | `/employees/:id/subordinates` | Direct reports for one manager |
| `GET` | `/teams` | Manager-wise team listing |

### Departments

| Method | Path | Purpose |
| --- | --- | --- |
| `GET` | `/departments` | Department list and employee counts |
| `GET` | `/departments/new` | New department form |
| `POST` | `/departments` | Create department |
| `GET` | `/departments/:id` | Department details and assigned employees |
| `GET` | `/departments/:id/edit` | Edit department form |
| `PATCH` / `PUT` | `/departments/:id` | Update department |
| `DELETE` | `/departments/:id` | Delete an empty department |

### Authentication

| Method | Path | Purpose |
| --- | --- | --- |
| `GET` | `/users/sign_up` | Registration form |
| `POST` | `/users` | Register account |
| `GET` | `/users/sign_in` | Sign-in form |
| `POST` | `/users/sign_in` | Sign in |
| `DELETE` | `/users/sign_out` | Sign out |
| `GET` | `/users/password/new` | Request password reset |
| `POST` | `/users/password` | Send password reset instructions |
| `GET` | `/users/edit` | Edit account |
| `PATCH` / `PUT` | `/users` | Update account |
| `DELETE` | `/users` | Delete account |

Use `bin/rails routes` to see the route helpers and the complete route list
generated by the installed Rails and Devise versions.

## Database and migrations

SQLite is configured in `config/database.yml`. Prepare the database for a new
checkout with:

```sh
bin/rails db:prepare
```

After pulling migrations, update an existing local database with:

```sh
bin/rails db:migrate
```

The department/status migration creates the `departments` table, adds
`department_id`, `active`, and `joining_date` to employees, and removes the
previous free-text department field. Existing department names are converted
into department records and associated back to employees. Existing joining
dates are initialized from each employee's `created_at` date; existing
employees default to Active.

Do not edit `db/schema.rb` manually. Rails updates it when migrations run.

## Tests and code quality

Run all tests:

```sh
bin/rails test
```

Run focused employee, department, and model tests:

```sh
bin/rails test test/controllers/employees_controller_test.rb test/controllers/departments_controller_test.rb test/models/employee_test.rb
```

Run the Rails/Ruby style checks for the project:

```sh
bundle exec rubocop
```

The tests cover employee and department CRUD, authentication-protected pages,
manager-wise team display, employee search and filters, department employee
counts, and model validation.

Test users and employee/department records in `test/fixtures` are for the test
suite only. They are not production or development seed accounts.

## Project structure

| Path | Contents |
| --- | --- |
| `app/controllers/employees_controller.rb` | Employee CRUD, search, filters, and teams |
| `app/controllers/departments_controller.rb` | Department CRUD and employee counts |
| `app/models/employee.rb` | Employee fields, relationships, validation, search scopes |
| `app/models/department.rb` | Department relationship and name validation |
| `app/views/employees/` | Employee directory, forms, details, and team views |
| `app/views/departments/` | Department directory, forms, and employee list |
| `app/views/devise/` | Bootstrap-styled authentication and account views |
| `app/assets/stylesheets/application.scss` | Bootstrap Sass entrypoint |
| `config/routes.rb` | Application and Devise routes |
| `db/migrate/` | Database schema changes |
| `test/` | Automated tests and fixtures |

## Troubleshooting

- **Migration pending:** run `bin/rails db:migrate`.
- **No departments available in the employee form:** create a department at
  `/departments` first.
- **Cannot delete a department:** it still has employees assigned. Reassign or
  delete them, then retry.
- **Cannot access employees or departments:** sign in at `/users/sign_in`.
- **Bootstrap stylesheet missing or Sass build fails:** check that the bundle
  is installed with `bundle install`, then retry the Rails command.
