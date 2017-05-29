module UserStatistics
    def cumulative_earnings_from_jd
    self.job_descriptions.sum(:earnings).to_f
  end

  def cumulative_earnings_from_applicants
    self.applicants.sum(:earnings).to_f
  end

  def total_number_of_hired_applicants
    self.applicants.count
  end

  def number_of_successful_deals
    self.job_descriptions.where(completed: true).count
  end

  def has_any_successful_deals?
    self.job_descriptions.where(completed: true).any? ? true : false  
  end

  def number_of_companies
    self.companies.count
  end
  
  def number_of_roles
    self.job_descriptions.count
  end    

  def earning_from_roles
    (self.job_descriptions.where(completed: true).sum(:earnings).to_f).round(2)  
  end

  def number_of_applicants
    self.applicants.count
  end

  def earning_from_applicants
    (self.applicants.sum(:earnings).to_f).round(2)
  end

  def number_of_hired_applicants
    self.applicants.where(status: "hired").count
  end

  def number_of_applicants_not_hired 
    self.applicants.where(status: "not hired").count
  end
  
  def time_frame(date, obj)
    if date.nil?
      0
    else 
      if !obj.nil? && (Time.now.to_date - date.to_date).to_f == 0.0
        1
      else
      	(Time.now.to_date - date.to_date).to_f
      end	
    end
  end

  def return_date_if_present(x)
    x.nil? ? nil : x.created_at 
  end

  def company_acquisition_rate
    begin
      (self.companies.count/time_frame(return_date_if_present(self.companies.first), self.companies.first)).round(2)
    rescue ZeroDivisionError
      0 
    end
  end 

  def applicant_acquisition_rate
    begin
      (self.applicants.count/time_frame(return_date_if_present(self.applicants.first), self.applicants.first)).round(2)
    rescue ZeroDivisionError
      0
    end
  end

  def cumulative_earning_rate
    self.cumulative_earnings/time_frame(self.created_at)
  end	
end