class RequiredExperiencesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_jd, except: [:update_button]
  before_action :set_experience, only: [:show, :edit, :update, :destroy]

  def index
  	@experiences = @jd.required_experiences.all
  end

  def show
  end

  def new
  	@experience = @jd.required_experiences.build
  end

  def create
  	@experience = @jd.required_experiences.build(exp_params)

  	if @experience.save 
  	  flash[:success] = "successufully added an experience"
  	  redirect_to company_job_description_url(@jd.company, @jd)
  	else
  	  flash.now[:alert] = "oops! something went wrong"
  	  render :new
  	end

  end

  def edit
  end

  def update
  	if @experience.update(exp_params)
  	  @experience.update(update_button: false) 	
  	  flash[:success] = "successufully updated an experience"
  	  redirect_to :back 
  	else
  	  flash.now[:alert] = "oops! something went wrong"
  	  render :edit	
  	end
  end

  def destroy
  	@experience.destroy
  	flash[:success] = "deletion successfully done"
  	redirect_to :back 
  end

  def update_button
  	@experience = RequiredExperience.find(params[:id])
  	@experience.update(update_button: true)
  	redirect_to :back
  end


  private 

  def set_jd
  	@jd = JobDescription.find(params[:job_description_id])
  end

  def set_experience
  	set_jd 
  	@experience = @jd.required_experiences.find(params[:id])
  end

  def exp_params
  	params.require(:required_experience).permit(:experience, :years, :update_button)
  end
end
