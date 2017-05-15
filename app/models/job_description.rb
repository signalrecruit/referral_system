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

  def any_applicant_hired?
    self.applicants.any?  { |applicant| applicant.hired? }
  end

  def calculate_cumulative_earnings
    @cumulative_earnings = 0
    self.class.where(user_id: self.user.id).each do |job_description|
      @cumulative_earnings += job_description.earnings
    end
    @cumulative_earnings
  end

  def calculate_jd_worth
    self.update(worth: self.vacancy_worth * vacancies)
  end

  def earning_per_jd
    @earnings = 0.0
    any_applicant_hired? ? @number_of_hired_applicants = self.applicants.where(status: "hired").count : @number_of_hired_applicants = 0
    @earnings = self.percent_worth/100 * self.worth/self.vacancies * @number_of_hired_applicants
    @earnings
  end

  def earning_algorithm
    if any_applicant_hired?
      self.update(earnings: earning_per_jd)
      self.user.update(cumulative_earnings: calculate_cumulative_earnings)
    else
      # self.update(earnings: 0.0)
      self.user.update(cumulative_earnings: calculate_cumulative_earnings)
    end
  end
end
