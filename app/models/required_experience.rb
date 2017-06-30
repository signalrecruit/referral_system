class RequiredExperience < ActiveRecord::Base
  belongs_to :job_description

  validates :experience, :years, presence: true
  validates :years, numericality: { greater_than_or_equal_to: 0 }

  def updated?
  	return true if self.update_button?
  end
end
