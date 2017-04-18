class Requirement < ActiveRecord::Base
  belongs_to :job_description
  has_many :activities, as: :trackable, dependent: :destroy

  validates :content, presence: true

  def updated?
  	return true if self.update_button?
  end
end
