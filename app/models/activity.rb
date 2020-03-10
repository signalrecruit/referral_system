require "job_description"
class Activity < ActiveRecord::Base
  belongs_to :user
  belongs_to :trackable, polymorphic: true

  def role_expired?
    jd = JobDescription.find(self.trackable_id) 
    jd.expiration_date < DateTime.now
  end
end
