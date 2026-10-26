class DepartmentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_department, only: [ :show, :edit, :update, :destroy ]

  def index
    @departments = Department.left_joins(:employees)
      .select("departments.*, COUNT(employees.id) AS employees_count")
      .group("departments.id")
      .order(:name)
  end

  def show
    @employees = @department.employees.includes(:manager, :department).order(:name)
  end

  def new
    @department = Department.new
  end

  def create
    @department = Department.new(department_params)

    if @department.save
      redirect_to @department, notice: "Department created successfully."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @department.update(department_params)
      redirect_to @department, notice: "Department updated successfully."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @department.destroy
    if @department.destroyed?
      redirect_to departments_path, notice: "Department deleted successfully.", status: :see_other
    else
      redirect_to @department, alert: @department.errors.full_messages.to_sentence, status: :see_other
    end
  end

  private

  def set_department
    @department = Department.find(params[:id])
  end

  def department_params
    params.require(:department).permit(:name)
  end
end
