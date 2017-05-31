module AlgorithmForApplicant
  def none? 
    return true if self.status == "none"
  end 

  def shortlisted?
  	return true if self.status == "shortlisted"
  end

  def interviewing?
  	return true if self.status == "interviewing"
  end

  def testing?
  	return true if self.status == "testing"
  end

  def salary_negotiation?
    return true if self.status == "salary negotiation"
  end

  def hired?
  	return true if self.status == "hired"
  end

  def not_hired?
  	return true if self.status == "not hired"
  end  

  def applicant_hired?
    self.hired? ? true : false
  end

  def calculate_cumulative_earnings
    @cumulative_earnings = 0
    self.class.where(user_id: self.user).each do |applicant|
      @cumulative_earnings += applicant.earnings
    end
    @cumulative_earnings.round(2)
  end

  def pay_user_when_applicant_is_hired
    if applicant_hired?
      self.update(earnings: (self.job_description.vacancy_percent_worth/100 * ( self.salary == 0.0 ? self.job_description.vacancy_worth : self.salary)).round(2))
      self.user.update(cumulative_earnings: calculate_cumulative_earnings)
    else
      self.update(earnings: 0.0)
      self.user.update(cumulative_earnings: calculate_cumulative_earnings)
    end   
  end

  def applicant_re_negotiated?
    self.salary != self.job_description.vacancy_worth
  end

  def update_salary
    if !self.hired? && !applicant_re_negotiated?
      self.update(salary: self.job_description.vacancy_worth.round(2))  
    end
    self.update(salary: self.job_description.vacancy_worth.round(2)) if !self.hired? && !self.salary_negotiation?
  end
end