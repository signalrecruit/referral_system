class Requirement < ActiveRecord::Base
  belongs_to :job_description

  validates :content, presence: true

  def updated?
  	return true if self.update_button?
  end
end
