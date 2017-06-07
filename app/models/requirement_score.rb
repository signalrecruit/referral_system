class RequirementScore < ActiveRecord::Base
  belongs_to :applicant
  belongs_to :job_description
  belongs_to :requirement

  after_save :calculate_applicant_score


  def calculate_applicant_score
   	
  end
end
