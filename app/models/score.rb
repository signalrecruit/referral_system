class Score < ActiveRecord::Base
  belongs_to :job_description
  belongs_to :applicant
end
