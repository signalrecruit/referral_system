class Qualification < ActiveRecord::Base
  belongs_to :job_description
  validates :certificate, :field_of_study, presence: true

  def updated?
  	self.update_button?
  end
end
