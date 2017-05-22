class Applicant < ActiveRecord::Base
  belongs_to :company
  belongs_to :job_description, counter_cache: :number_of_applicants
  belongs_to :user
   has_many :activities, as: :trackable, dependent: :destroy

  validates :name, :email, :phonenumber, :location, :min_salary, :max_salary,
   presence: true

  def updated?
  	return true if self.update_button?
  end 
  
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
    @cumulative_earnings
  end

  def pay_user_when_applicant_is_hired
    if applicant_hired?
      self.update(earnings: self.job_description.vacancy_percent_worth/100 * ( self.salary == 0.0 ? self.job_description.vacancy_worth : self.salary))
      self.user.update(cumulative_earnings: calculate_cumulative_earnings)
    else
      self.update(earnings: 0.0)
      self.user.update(cumulative_earnings: calculate_cumulative_earnings)
      # byebug
    end   
  end

  def re_negotiate_salary
  end
end

