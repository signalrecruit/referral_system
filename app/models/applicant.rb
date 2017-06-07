class Applicant < ActiveRecord::Base
  include AlgorithmForApplicant

  belongs_to :company
  belongs_to :job_description, counter_cache: :number_of_applicants
  belongs_to :user
  has_many :activities, as: :trackable, dependent: :destroy
  has_many :requirement_scores, dependent: :destroy

  accepts_nested_attributes_for :requirement_scores, reject_if: :all_blank

  validates :name, :email, :phonenumber, :location, :min_salary, :max_salary,
   presence: true

  # after_touch :calculate_requirement_score 

  def updated?
  	return true if self.update_button?
  end 

  # def calculate_requirement_score
  #   if self.requirement_scores.any? 
  #     self.update(requirement_score: self.requirement_scores.where(job_description_id: self.job_description_id).sum(:score))
  #   end
  # end
end

