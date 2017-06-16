require "score"
require "applicant_record"
class Applicant < ActiveRecord::Base
  include AlgorithmForApplicant

  belongs_to :company
  belongs_to :job_description, counter_cache: :number_of_applicants
  belongs_to :user
  has_many :activities, as: :trackable, dependent: :destroy
  has_many :requirement_scores, dependent: :destroy
  has_many :scores, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :applicant_records, dependent: :destroy

  accepts_nested_attributes_for :requirement_scores, reject_if: :all_blank

  validates :name, :email, :phonenumber, :location, :min_salary, :max_salary, presence: true


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
    applicant_record = ApplicantRecord.create applicant_id: self.id, applicant_name: self.name,
     job_description_id: job_description.id, role: job_description.job_title, score_id: score.id, applicant_score: score.id
  end

  def update_applicant_history(job_description)
    applicant_record = ApplicantRecord.find_by job_description_id: job_description
    
    comment = Comment.find_by applicant_id: self.id, job_description_id: job_description.id
    score = Score.find_by job_description_id: job_description.id, applicant_id: self.id
    
    applicant_record.update(applicant_score: score.applicant_score, role: job_description.job_title, applicant_status: self.status, applicant_name: self.name,
      comment_id: comment.try(:id), feedback: comment.try(:feedback))
  end

  def updated?
  	return true if self.update_button?
  end 
end

