require "score"
class Applicant < ActiveRecord::Base
  include AlgorithmForApplicant

  belongs_to :company
  belongs_to :job_description, counter_cache: :number_of_applicants
  belongs_to :user
  has_many :activities, as: :trackable, dependent: :destroy
  has_many :requirement_scores, dependent: :destroy
  has_many :scores, dependent: :destroy

  accepts_nested_attributes_for :requirement_scores, reject_if: :all_blank

  validates :name, :email, :phonenumber, :location, :min_salary, :max_salary, presence: true

  after_create :calculate_applicant_score


  def calculate_applicant_score
    applicant_score = (self.requirement_scores.where(applicant_id: self.id, job_description_id: self.job_description_id).sum(:score)/self.requirement_scores.count) * 100
    
    1.times do 
      score = Score.new
      score.job_description_id = self.job_description_id
      score.applicant_id = self.id
      score.applicant_score = applicant_score
      score.save
    end
  end

  def updated?
  	return true if self.update_button?
  end 
end

