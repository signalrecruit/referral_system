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
    implement_authorization_policy_if_applicable
  end

  def implement_authorization_policy_if_applicable
    company = @applicant.company 
    role = Role.find_by role: "owner", resource_id: company.id, resource_type: "Company"
    if role 
      Role.create role: "owner", resource_id: @applicant.id, resource_type: @applicant.class.name, user_id: role.user_id
    end
  end
end