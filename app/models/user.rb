class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  enum admin_status: [:user, :normal_admin, :super_admin]
  has_many :companies, dependent: :destroy
  has_many :activities, as: :trackable, dependent: :destroy
  has_many :applicants, dependent: :destroy
  has_many :job_descriptions, dependent: :destroy
  has_many :messages, dependent: :destroy

  def updated?
  	return true if self.update_button?
  end


  # include the methods below as a module

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
  
  def time_frame(date)
    date.nil? ? 0 : (Time.now.to_date - date.to_date).to_f
  end

  def return_date_if_present(x)
    x.nil? ? nil : x.created_at 
  end

  def company_acquisition_rate
    begin
      self.companies.count/time_frame(return_date_if_present(self.companies.first))
    rescue ZeroDivisionError
      0 
    end
  end 

  def applicant_acquisition_rate
    begin
      self.applicants.count/time_frame(return_date_if_present(self.applicants.first))
    rescue ZeroDivisionError
      0
    end
  end

  def cumulative_earning_rate
    self.cumulative_earnings/time_frame(self.created_at)
  end
end
