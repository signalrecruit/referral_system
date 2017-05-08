class JobDescription < ActiveRecord::Base
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

  def all_vacancies_filled?
    self.vacancies == self.applicants.count ? true : false
  end

   # all applicants are hired for this role
  def all_applicants_are_hired?
    self.applicants.all? { |applicant| applicant.hired? }    
  end

  def calculate_cumulative_earnings
    @cumulative_earnings = 0
    self.class.where(user_id: self.user.id).each do |job_description|
      @cumulative_earnings += job_description.earnings
    end
    @cumulative_earnings
  end

  def earning_algorithm
    if all_applicants_are_hired? && all_vacancies_filled?
      self.update(earnings: self.percent_worth/100 * self.worth)
      self.user.update(cumulative_earnings: calculate_cumulative_earnings)
    else
      self.update(earnings: 0.0)
      self.user.update(cumulative_earnings: calculate_cumulative_earnings)
    end
  end
end
