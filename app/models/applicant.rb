class Applicant < ActiveRecord::Base
  include AlgorithmForApplicant

  belongs_to :company
  belongs_to :job_description, counter_cache: :number_of_applicants
  belongs_to :user
   has_many :activities, as: :trackable, dependent: :destroy

  validates :name, :email, :phonenumber, :location, :min_salary, :max_salary,
   presence: true

  def updated?
  	return true if self.update_button?
  end 
end

