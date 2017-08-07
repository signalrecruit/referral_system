require "score"
require "applicant_record"
require "activity"
class Applicant < ActiveRecord::Base
  include AlgorithmForApplicant

  mount_uploader :cv, CvUploader

  belongs_to :company
  belongs_to :job_description, counter_cache: :number_of_applicants
  belongs_to :user
  has_many :activities, as: :trackable, dependent: :destroy
  has_many :requirement_scores, dependent: :destroy
  has_many :scores, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :applicant_records, dependent: :destroy

  accepts_nested_attributes_for :requirement_scores, reject_if: :all_blank

  validates :name, :email, :phonenumber, :location, :min_salary, :max_salary, :cv, presence: true
  validates :phonenumber, format: { with: /\A[-+]?[0-9]*\.?[0-9]+\Z/, message: "only allows numbers" }
  validates :min_salary, :max_salary, numericality: { greater_than_or_equal_to: 0 }



  # custom validation
  validate :max_salary_cannot_be_less_than_min_salary

  def max_salary_cannot_be_less_than_min_salary
    errors.add(:max_salary, "can't be less than min salary") if (max_salary.present? || min_salary.present?) && max_salary < min_salary 
  end
  
  def calculate_applicant_score
    applicant_score = ((self.requirement_scores.where(applicant_id: self.id, job_description_id: self.job_description_id).sum(:score)/self.requirement_scores.count) * 100).round(2)
    score = Score.find_by applicant_id: self.id, job_description_id: self.job_description_id
      if score 
        score.update(applicant_score: applicant_score)
      else
       score = Score.new
       score.job_description_id = self.job_description_id
       score.applicant_id = self.id
       score.applicant_score = applicant_score.round
       score.save
     end
  end

  def record_applicant_history(job_description)
    score = Score.find_by job_description_id: job_description.id, applicant_id: self.id
    record = ApplicantRecord.create applicant_id: self.id, applicant_name: self.name,
     job_description_id: job_description.id, role: job_description.job_title, score_id: score.id, applicant_score: score.id,
      company_name: job_description.company.company_name, applicant_status: self.status
  end

  def update_applicant_history(job_description)
    record = ApplicantRecord.find_by job_description_id: job_description, applicant_id: self.id
    
    comment = self.comments.last #temporary solution
    score = Score.find_by job_description_id: job_description.id, applicant_id: self.id
    
    record.update(applicant_score: score.applicant_score, role: job_description.job_title, applicant_status: self.status, applicant_name: self.name,
      comment_id: comment.try(:id), feedback: comment.try(:feedback), company_name: job_description.company.company_name)
  end

  def updated?
  	return true if self.update_button?
  end 

  def remove_related_activities_from_newsfeed
    activities = Activity.where(trackable_type: "Applicant", trackable_id: self.id)  

    activities.delete_all if activities.any?
    self.applicant_records.delete_all if self.applicant_records.any?
    self.comments.delete_all if self.comments.any?
    self.scores.delete_all if self.scores.any?
    self.requirement_scores.delete_all if self.requirement_scores.any?    
    self.destroy
  end
end

