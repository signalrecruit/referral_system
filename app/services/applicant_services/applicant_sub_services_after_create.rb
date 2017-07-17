class ApplicantSubServicesAfterCreate 
  def initialize(params)
  	@applicant = params[:applicant]
  	@jd = params[:jd]
  	@current_user = params[:current_user]
  end

  def initiate_sub_services
    sub_services
  end


  private 

  def sub_services
  	@applicant.update(company_id: @jd.company.id, user_id: @current_user.id)
  	@applicant.calculate_applicant_score
    @applicant.record_applicant_history @jd
    @applicant.job_description.update_jd_status
    @applicant.update_salary
  end
end