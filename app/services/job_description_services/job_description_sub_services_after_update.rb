class JobDescriptionSubServicesAfterUpdate
  def initialize(params)
    @job_description = params[:job_description]	
  end

  def initiate_sub_services
  	sub_services 
  end


  private 

  def sub_services
  	@job_description.update_applicants_salary
  	@job_description.update(update_button: false)	
  end
end
