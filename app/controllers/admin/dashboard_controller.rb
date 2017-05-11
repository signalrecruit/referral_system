class Admin::DashboardController < Admin::ApplicationController
  layout "admin"	

  def dashboard
  	display_analytics
  end

  
  def activity_feed
  end

  private

  def display_analytics
  	total_revenue
  	total_number_of_hired_applicants
  	total_number_of_company_deals
  	top_earner
  end

  def total_revenue
  	@completed_jds = []
    JobDescription.all.each do |jd|
      if jd.applicants.all? { |applicant| applicant.hired? }
      	@completed_jds << jd.worth
      end	
      @total_revenue = @completed_jds.inject(0){ |sum, x| sum + x }
    end	
  end

  def total_number_of_hired_applicants
    @number_of_hired_applicants = Applicant.all.where(status: "hired").count     
  end

  def total_number_of_company_deals
    @number_of_deals = Company.all.where(deal: true).count
  end

  def top_earner
    @top_earner = User.all.order(cumulative_earnings: :desc).first
  end
end
