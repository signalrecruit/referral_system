class RequirementScore < ActiveRecord::Base
  belongs_to :applicant
  belongs_to :job_description
  belongs_to :requirement
end
