class JobDescription < ActiveRecord::Base
  include AlgorithmForJD

  belongs_to :company
  belongs_to :user
  has_many :requirements, dependent: :destroy
  has_many :activities, as: :trackable, dependent: :destroy
  has_many :applicants, dependent: :destroy
  has_many :qualifications, dependent: :destroy
  has_many :required_experiences, dependent: :destroy

  validates :job_title, :role_description, :experience, :min_salary, :max_salary, :vacancies, presence: true

  def updated?
  	return true if self.update_button?
  end
end
