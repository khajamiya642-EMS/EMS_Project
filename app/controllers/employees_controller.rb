class EmployeesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_employee, only: [ :show, :edit, :update, :destroy ]
  before_action :set_form_options, only: [ :new, :create, :edit, :update ]

  def index
    @departments = Department.order(:name)
    @managers = Employee.order(:name)
    @employees = Employee.includes(:manager, :department)
      .search(params[:q])
      .with_status(params[:status])
      .joined_from(params[:joined_from])
      .joined_to(params[:joined_to])
      .order(:name)
    @employees = @employees.where(department_id: params[:department_id]) if params[:department_id].present?
    @employees = @employees.where(manager_id: params[:manager_id]) if params[:manager_id].present?
  end

  def show
  end

  def teams
    @managers = Employee.where(
      id: Employee.where.not(manager_id: nil).select(:manager_id).distinct
    ).includes(:department, subordinates: [ :department, :manager ]).order(:name)
    @unassigned_employees = Employee.where(manager_id: nil).includes(:department).order(:name)
  end

  def subordinates
    @employee = Employee.find(params[:id])
    @employees = @employee.subordinates.includes(:manager, :department).order(:name)
  end

  def new
    @employee = Employee.new(department_id: params[:department_id])
  end

  def create
    @employee = Employee.new(employee_params)
    if @employee.save
      redirect_to @employee, notice: "Employee created successfully."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @employee.update(employee_params)
      redirect_to @employee, notice: "Employee updated successfully."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @employee.destroy
    redirect_to employees_path, notice: "Employee deleted successfully.", status: :see_other
  end

  private

  def set_employee
    @employee = Employee.find(params[:id])
  end

  def set_form_options
    @managers = Employee.where.not(id: @employee&.id).order(:name)
    @departments = Department.order(:name)
  end

  def employee_params
    params.require(:employee).permit(
      :name, :email, :phone, :salary, :manager_id, :department_id, :active, :joining_date
    )
  end
end
