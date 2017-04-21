class Admin::ApplicantsController < Admin::ApplicationController
  before_action :set_jd
  before_action :set_applicant, only: [:show]	
  layout "admin"
  	
  def index
  	@applicants = @jd.applicants.all
  end

  def show
  end



  private

  def set_jd
  	@jd = JobDescription.find(params[:job_description_id])
  end

  def set_applicant
  	set_jd 
  	@applicant = @jd.applicants.find(params[:id])
  end
end
