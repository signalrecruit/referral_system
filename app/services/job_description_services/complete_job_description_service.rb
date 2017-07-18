class CompleteJobDescriptionService
  def initialize(params)
  	@job_description = params[:job_description]
  end	

  def complete_jd
  	sub_services
  end


  private 

  def sub_services
  	@job_description.update(completed: true)
    @job_description.update_jd_status
  end
end