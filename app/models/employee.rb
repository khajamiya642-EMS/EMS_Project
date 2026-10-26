class Employee < ApplicationRecord
  belongs_to :department
  belongs_to :manager, class_name: "Employee", optional: true
  has_many :subordinates, class_name: "Employee", foreign_key: "manager_id", dependent: :nullify

  validates :name, :email, :phone, :salary, :joining_date, presence: true
  validates :email, uniqueness: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :salary, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validate :manager_cannot_be_self

  before_validation :set_default_joining_date, on: :create

  scope :search, lambda { |query|
    term = query.to_s.strip
    if term.present?
      pattern = "%#{sanitize_sql_like(term)}%"
      base = left_joins(:department)
      results = base
        .where("employees.name LIKE :pattern OR employees.email LIKE :pattern OR departments.name LIKE :pattern", pattern: pattern)
        .or(base.where(manager_id: Employee.where("employees.name LIKE :pattern OR employees.email LIKE :pattern", pattern: pattern).select(:id)))
      results = results.or(base.where(id: term.to_i)) if term.match?(/\A\d+\z/)
      results
    else
      all
    end
  }

  scope :with_status, lambda { |status|
    case status
    when "active" then where(active: true)
    when "inactive" then where(active: false)
    else all
    end
  }

  scope :joined_from, ->(date) { date.present? ? where("joining_date >= ?", date) : all }
  scope :joined_to, ->(date) { date.present? ? where("joining_date <= ?", date) : all }

  def status
    active? ? "Active" : "Inactive"
  end

  private

  def set_default_joining_date
    self.joining_date ||= Date.current
  end

  def manager_cannot_be_self
    errors.add(:manager, "can't be the employee") if manager_id.present? && manager_id == id
  end
end
