class RequirementsController < ApplicationController
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
      flash[:success] = "successfully created a requirement"
      redirect_to job_description_requirements_url(@jd)
    else
      flash.now[:alert] = "oops! sthg went wrong"
      render :new  
    end  
  end

  def edit
  end

  def update
    if @requirement.update(requirement_params)
      @requirement.update(update_button: false)
      flash[:success] = "successfully updated a requirement"
      redirect_to :back
    else
      flash.now[:alert] = "ooops! sthg went wrong"
      redirect_to :back
    end 
  end

  def destroy
    @requirement.destroy
    flash[:success] = "requirement successfully deleted"
    redirect_to :back
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
