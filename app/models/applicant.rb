class Applicant < ActiveRecord::Base
  belongs_to :company
  belongs_to :job_description
  belongs_to :user
   has_many :activities, as: :trackable, dependent: :destroy

  validates :name, :email, :phonenumber, :location, :min_salary, :max_salary,
   presence: true

  def updated?
  	return true if self.update_button?
  end 

  def none?
  	return true if self.status == "shortlisted"
  end

  def interviewing?
  	return true if self.status == "interviewing"
  end

  def testing?
  	return true if self.status == "testing"
  end

  def salary_negotiation_successful?
    return true if self.status == "yes"
  end

  def hired?
  	return true if self.status == "hired"
  end

  def not_hired?
  	return true if self.status == "not hired"
  end
end

