class Admin::RequirementsController < Admin::ApplicationController
  before_action :set_jd
  before_action :set_requirement, only: [:show]	
  layout "admin"
  	
  
  def index
    @requirements = @jd.requirements.all	
  end

  def show
  end


  private

  def set_jd
    @jd = JobDescription.find(params[:job_description_id])	
  end

  def set_requirement
  	set_jd
  	@requirement = @jd.requirements.find(params[:id])
  end

  def requirement_params
  	params.require(:requirement).permit(:content)
  end
end
