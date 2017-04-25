class QualificationsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_jd, except: [:update_button] 
  before_action :set_qualification, only: [:show, :edit, :update, :destroy]


  def index
  	@qualifications = @jd.qualifications.all
  end

  def show
  end

  def new
  	@qualification = @jd.qualifications.build
  end

  def create
  	@qualification = @jd.qualifications.build(qualification_params)

  	if @qualification.save 
  	  flash[:success] = "added qualification successfully"
  	  redirect_to job_description_qualifications_url(@jd)
  	else
  	  flash.now[:alert] = "oops! something went wrong"
  	  render :new 	
  	end
  end

  def edit
  end

  def update
  	if @qualification.update(qualification_params)
  	   @qualification.update(update_button: false)	
  	  flash[:success] = "successfully updated qualification"
  	  redirect_to job_description_qualifications_url(@jd)
  	else 
  	  flash.now[:alert] = "oops! something went wrong"
  	  render :edit	
  	end
  end

  def destroy
  	@qualification.destroy
  	flash[:success] = "successfully deleted a qualification"
  	redirect_to :back
  end

  def update_button
  	@qualification = Qualification.find(params[:id])
  	@qualification.update(update_button: true)
  	redirect_to :back
  end

  
  private 

  def set_jd
  	@jd = JobDescription.find(params[:job_description_id])
  end

  def set_qualification
  	set_jd
  	@qualification = @jd.qualifications.find(params[:id])
  end

  def qualification_params
  	params.require(:qualification).permit(:certificate, :field_of_study,
  	 :update_button)
  end
end
