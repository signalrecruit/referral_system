class ApplicantSubServicesAfterUpdate
  def initialize(params)
  	@applicant = params[:applicant]
  	@jd = params[:jd]
  end

  def initiate_sub_services
  	sub_services
  end


  private 

  def sub_services
    @applicant.update(update_button: false) 	
    @applicant.calculate_applicant_score
    @applicant.update_applicant_history @jd
  end
end