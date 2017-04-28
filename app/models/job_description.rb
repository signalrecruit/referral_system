class JobDescription < ActiveRecord::Base
  belongs_to :company
  has_many :requirements, dependent: :destroy
  has_many :activities, as: :trackable, dependent: :destroy
  has_many :applicants, dependent: :destroy
  has_many :qualifications, dependent: :destroy
  has_many :required_experiences, dependent: :destroy

  validates :job_title, :role_description, :experience, :min_salary, :max_salary, :vacancies, presence: true

  def updated?
  	return true if self.update_button?
  end




  # algorithm
  
  def all_applicants_hired?
    self.applicants.all? { |applicant| applicant.status == "hired"}
  end

  def earning_algorithm
    if all_applicants_hired?  
      if self.vacancies == self.number_of_applicants 
        self.update(earnings: self.percent_worth/100 * self.worth)
      end
    else
      self.update(earnings: 0.00)
    end
  end
end
