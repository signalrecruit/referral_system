require "requirement_score"
class JobDescription < ActiveRecord::Base
  include AlgorithmForJD

  belongs_to :company
  belongs_to :user
  has_many :requirements, dependent: :destroy
  has_many :activities, as: :trackable, dependent: :destroy
  has_many :applicants, dependent: :nullify
  has_many :qualifications, dependent: :destroy
  has_many :required_experiences, dependent: :destroy
  has_many :attachments, dependent: :destroy

  accepts_nested_attributes_for :attachments, reject_if: :all_blank

  validates :job_title, :role_description, :experience, :min_salary, :max_salary, :vacancies, presence: true
  validates :actual_worth, :percent_worth, :applicant_worth, :applicant_percent_worth, :vacancy_worth, :vacancy_percent_worth,
  :potential_worth, :experience, :vacancies, :min_salary, :max_salary, numericality: { greater_than_or_equal_to: 0 }

  # custom validation
  validate :max_salary_cannot_be_less_than_min_salary

  def max_salary_cannot_be_less_than_min_salary
    errors.add(:max_salary, "can't be less than min salary") if max_salary < min_salary 
  end

  def updated?
  	return true if self.update_button?
  end

  def role_expired?
    return true if self.expiration_date < Time.now 
  end

  def remove_related_activities_from_newsfeed
    activities = Activity.where(trackable_type: "JobDescription", trackable_id: self.id).all

    activities.delete_all if activities.any?
    RequirementScore.where(job_description_id: self.id).delete_all if RequirementScore.where(job_description_id: self.id).any?

    delete_all_applicant_related_activities if self.applicants.any?
    nullify_all_applicants_for_this_jd if self.applicants.any?
    self.qualifications.delete_all if self.qualifications.any?
    self.required_experiences.delete_all if self.required_experiences.any?
    self.requirements.delete_all if self.requirements.any?
    ApplicantRecord.where(job_description_id: self.id).delete_all
    Score.where(job_description_id: self.id).delete_all
    self.destroy
  end


  private

  def delete_all_applicant_related_activities
    self.applicants.each do |applicant|
      (Activity.find_by(trackable_type: "Applicant", trackable_id: applicant.id)).destroy
    end
  end

  def nullify_all_applicants_for_this_jd
    self.applicants.each do |applicant|
      applicant.update(job_description_id: nil)
    end
  end
end
