class ApplicantRecord < ActiveRecord::Base
  belongs_to :job_description
  belongs_to :score
  belongs_to :comment
  belongs_to :applicant
end
