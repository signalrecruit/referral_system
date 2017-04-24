class ApplicantsController < ApplicationController
  before_action :set_jd, except: [:update_button]
  before_action :set_applicant, only: [:show, :edit, :update, :destroy]

  def index
  	@applicants = @jd.applicants.all
  end

  def show
  end

  def new
  	@applicant = @jd.applicants.build
  end

  def create
  	@applicant = @jd.applicants.build(applicant_params)

  	if @applicant.save 
  	  @applicant.update(company_id: @jd.company.id)	
  	  track_activity @applicant, "added an applicant", current_user.id	
  	  @applicant.update(user_id: current_user.id)	
  	  flash[:success] = "you successfully added an applicant to this job description"
  	  redirect_to [@jd, @applicant]
  	else
  	  flash.now[:alert] = "oops! something went wrong"
  	  render :new	
  	end
  end

  def edit
  end

  def update
  	if @applicant.update(applicant_params)
  	  @applicant.update(update_button: false) 	
  	  flash[:success] = "you successfully updated this applicant"
  	  if request.referrer == job_description_applicants_url(@jd)
  	  	redirect_to :back
  	  else
  	  	redirect_to [@jd, @applicant]
  	  end
  	else
  	  flash.now[:alert] = "oops! something went wrong"
  	  render :edit
  	end
  end

  def destroy
  	@applicant.destroy
  	flash[:success] = "deletion successful"
  	redirect_to job_description_applicants_url(@jd)
  end

  def update_button
  	@applicant = Applicant.find(params[:id])
  	@applicant.update(update_button: true)
  	redirect_to :back
  end


  private 

  def set_jd
  	@jd = JobDescription.find(params[:job_description_id])
  end

  def set_applicant
  	set_jd 
  	@applicant = @jd.applicants.find(params[:id])
  end

  def applicant_params
  	params.require(:applicant).permit(:name, :email, :phonenumber, :location, :min_salary,
  		 :max_salary, :company_id, :job_description_id, :user_id, :attachment, :update_button)
  end
end