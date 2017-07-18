class RequirementsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_jd, except: [:update_button]
  before_action :set_requirement, only: [:show, :edit, :update, :destroy]

  def index
    @requirements = @jd.requirements.all	
  end

  def show
  end

  def new
    @requirement = @jd.requirements.new
  end

  def create
    @requirement = @jd.requirements.build(requirement_params)
    
    if @requirement.save 
      on_success "successfully created a requirement", company_job_description_url(@jd.company, @jd)
    else
      on_failure "oops! sthg went wrong", :new
    end  
  end

  def edit
  end

  def update
    if @requirement.update(requirement_params)
      @requirement.update(update_button: false)
      on_success "successfully updated a requirement", :back
    else
      on_failure "ooops! sthg went wrong", :back
    end 
  end

  def destroy
    @requirement.destroy
    on_success "requirement successfully deleted", :back
  end

  def update_button
    @requirement = Requirement.find(params[:id])
    @requirement.update(update_button: true)
    redirect_to :back
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
