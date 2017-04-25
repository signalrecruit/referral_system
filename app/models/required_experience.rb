class RequiredExperience < ActiveRecord::Base
  belongs_to :job_description

  validates :experience, :years, presence: true

  def updated?
  	return true if self.update_button?
  end
end
