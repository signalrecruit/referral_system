class JobDescriptionSubServicesAfterCreate
  def initialize(params)
  	@job_description = params[:job_description]
  	@current_user = params[:current_user]
  end

  def initiate_sub_services
  	sub_services
  end


  private 

  def sub_services 
    @job_description.estimate_actual_and_potential_worth
    @job_description.update(user_id: @current_user.id)
  end
end