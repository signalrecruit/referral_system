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
    self.applicants.any? { |applicant| applicant.hired? }
  end

  def no_applicant_hired?
    self.applicants.all? { |applicant| !applicant.hired? }
  end

  def any_applicant_re_negotiated_salary?
    self.applicants.any? { |applicant| applicant.salary != self.vacancy_worth }
  end

  def calculate_cumulative_earnings
    @cumulative_earnings = 0
    self.class.where(user_id: self.user.id).each do |job_description|
      @cumulative_earnings += job_description.earnings
    end
    @cumulative_earnings
  end

 
  def calculate_jd_actual_worth
    self.update(actual_worth: self.applicants.sum(:salary).to_f)
  end

  def update_applicants_salary
    if no_applicant_hired?
      self.applicants.update_all(salary: self.potential_worth/self.vacancies)
      self.update(vacancy_worth: self.potential_worth/self.vacancies)
    end

    if self.applicants.any?
      self.applicants.each do |applicant|
        if applicant.salary == 0.0
          applicant.update(salary: self.vacancy_worth)
        elsif self.vacancy_worth == 0.0
          applicant.update(salary: vacancy_worth)  
        end  
      end  
    end
  end


  def earning_per_jd
    @earnings = 0.0
    any_applicant_hired? ? @number_of_hired_applicants = self.applicants.where(status: "hired").count : @number_of_hired_applicants = 0
    @earnings = self.percent_worth/100 * self.actual_worth/self.vacancies * @number_of_hired_applicants
    @earnings
  end

  def earning_algorithm
    if any_applicant_hired?
      self.update(earnings: earning_per_jd)
      self.user.update(cumulative_earnings: calculate_cumulative_earnings)
    else
      self.update(earnings: 0.0)
      self.user.update(cumulative_earnings: calculate_cumulative_earnings)
    end
    update_applicant_earnings
  end

  def update_applicant_earnings
    self.applicants.each do |applicant|
      applicant.pay_user_when_applicant_is_hired
    end
  end

  def average_vacancy_worth
    self.applicants.sum(:salary).to_f/self.applicants.count
  end
end
