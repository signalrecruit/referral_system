class Comment < ActiveRecord::Base
  belongs_to :applicant
  belongs_to :job_description
  belongs_to :score
end
