# Employee Manager

A Rails employee directory with Devise authentication and Bootstrap styling.
Signed-in users can create, view, edit, and delete employees; create departments;
assign employees to departments and managers; browse manager-wise teams; search
by employee name, ID, email, department, or manager; and filter by department,
manager, active status, and joining-date range. Department pages display their
employee counts.

## Setup

Install the Ruby gems, prepare the SQLite database, and start Rails:

```sh
bundle install
bin/rails db:prepare
bin/rails server
```

Open the URL shown by the server and register an account to sign in.
Create a department first, then assign it when creating an employee. Existing
department names are migrated into department records.

## Tests

Run the application test suite with:

```sh
bin/rails test
```
