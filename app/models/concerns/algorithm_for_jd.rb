module AlgorithmForJD
  def all_vacancies_filled?
    self.vacancies == self.applicants.where(copy: false).count ? true : false
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
    self.applicants.any? { |applicant| applicant.salary != 0.0 }
  end

  def calculate_cumulative_earnings
    # @cumulative_earnings = 0
    # self.class.where(user_id: self.user.id).each do |job_description|
    #   @cumulative_earnings += job_description.earnings
    # end
    # @cumulative_earnings.round(2)

    @users = User.all.order(created_at: :asc).where(admin: false, admin_status: 0)
    @users.each do |user|
      @applicant_earnings = 0.0 
      @jd_earnings = 0.0
      user.applicants.each do |applicant|
        @applicant_earnings += applicant.earnings if applicant.hired?
      end

      user.job_descriptions.each do |jd|
        @jd_earnings += jd.earnings
      end
      user.update(cumulative_earnings: @applicant_earnings + @jd_earnings)
    end
  end

 
  def calculate_jd_actual_worth
    if all_vacancies_filled?
      self.update(actual_worth: (self.applicants.sum(:salary).to_f).round(2))
    else
      self.update(actual_worth: (self.vacancy_worth * self.vacancies).round(2))  
    end  
  end

  def update_applicants_salary
    if no_applicant_hired?
      self.applicants.update_all(salary: (self.potential_worth/self.vacancies).round(2))
      self.update(vacancy_worth: (self.potential_worth/self.vacancies).round(2))
    else
      self.update(vacancy_worth: (self.potential_worth/self.vacancies).round(2)) 
    end

    if self.applicants.any?
      self.applicants.each do |applicant|
        if applicant.salary == 0.0
          applicant.update(salary: self.vacancy_worth.round(2))
        elsif self.vacancy_worth == 0.0
          applicant.update(salary: vacancy_worth.round(2))  
        end  
      end  
    end
  end


  def earning_per_jd
    @earnings = 0.0
    calculate_jd_actual_worth
    update_applicants_salary
    any_applicant_hired? ? @number_of_hired_applicants = self.applicants.where(status: "hired").count : @number_of_hired_applicants = 0
    @earnings = self.percent_worth/100 * self.actual_worth/self.vacancies * @number_of_hired_applicants
    @earnings.round(2)
  end

  def earning_algorithm
    if self.applicants.any? && any_applicant_hired?
      self.update(earnings: earning_per_jd)
      # self.user.update(cumulative_earnings: calculate_cumulative_earnings)
      calculate_cumulative_earnings
    elsif self.applicants.any? && no_applicant_hired?
      self.update(earnings: 0.0)
      self.update(vacancy_worth: (self.potential_worth/self.vacancies).round(2))
      self.update(actual_worth: self.potential_worth)
      # self.user.update(cumulative_earnings: calculate_cumulative_earnings)
      calculate_cumulative_earnings
    elsif self.applicants.empty?
      self.update(earnings: 0.0)
      self.update(vacancy_worth: (self.potential_worth/self.vacancies).round(2))
      self.update(actual_worth: self.potential_worth)
      # self.user.update(cumulative_earnings: calculate_cumulative_earnings)  
      calculate_cumulative_earnings
    end
    update_applicant_earnings
    update_jd_status
  end

  def update_applicant_earnings
    self.applicants.each do |applicant|
      applicant.pay_user_when_applicant_is_hired
    end
  end

  def average_vacancy_worth
    (self.applicants.sum(:salary).to_f/self.applicants.count).round(2) 
  end
  
  def is_jd_completed?
    if self..qualifications.any? && self.required_experiences.any? && self.requirements.any?
      self.update(completed: true)   
    else
      self.update(completed: false)
    end  
  end

  def update_vacancy_status
    if self.all_vacancies_filled?
      self.update(vacancies_filled: true)
    else
      self.update(vacancies_filled: false)
    end
  end


  def update_jd_status
    update_vacancy_status
  end
end