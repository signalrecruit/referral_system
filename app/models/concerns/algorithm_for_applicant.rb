module AlgorithmForApplicant
  def none? 
    self.status == "none"
  end 

  def shortlisted?
  	self.status == "shortlisted"
  end

  def interviewing?
  	self.status == "interviewing"
  end

  def testing?
  	self.status == "testing"
  end

  def salary_negotiation?
    self.status == "salary negotiation"
  end

  def hired?
  	self.status == "hired"
  end

  def not_hired?
  	self.status == "not hired"
  end  

  def applicant_hired?
    self.hired?
  end

  def calculate_cumulative_earnings
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

  def pay_user_when_applicant_is_hired
    if applicant_hired?
      self.update(earnings: (self.job_description.vacancy_percent_worth/100 * ( self.salary == 0.0 ? self.job_description.vacancy_worth : self.salary)).round(2))
      calculate_cumulative_earnings
    else
      self.update(earnings: 0.0)
      calculate_cumulative_earnings
    end   
  end
  
  def applicant_re_negotiated?
    self.salary != self.job_description.vacancy_worth if !self.job_description.nil?
  end

  def update_salary
    if self.salary == 0.0
      self.update(salary: self.job_description.vacancy_worth.round(2)) if !self.job_description.nil?
    else
      self.update(salary: self.salary.round(2)) if !self.job_description.nil?
    end
  end
end
