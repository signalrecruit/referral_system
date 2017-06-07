class RequirementScore < ActiveRecord::Base
  belongs_to :applicant
  belongs_to :job_description

  before_save :produce_score_and_associate

  # def produce_content
  #   self.applicant.job_description.requirements.each do |requirement|
  #     self.update(requirement_content: requirement.content)	
  #   end
  # end
  
  def produce_score
    if self.input == true 
      self.update(score: 1)
    elsif self.input == false 
      self.update(score: 0)	
    end
  end

  def produce_score_and_associate
  	self.produce_score
  	self.update(job_description_id: self.applicant.job_description_id) 
  end
end
