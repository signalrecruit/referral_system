class Qualification < ActiveRecord::Base
  belongs_to :job_description
  validates :certificate, :field_of_study, presence: true

  def updated?
  	return true if self.update_button?
  end
end
