class JobDescriptionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_company, except: [:update_button]
  before_action :set_job_description, only: [:show, :edit, :update, :destroy]


  def index
  end

  def show
  end

  def new
  	@job_description = @company.job_descriptions.build
  end
  
  def create
  	@job_description = @company.job_descriptions.build(job_params)

  	if @job_description.save 
      track_activity @job_description, params[:action], current_user.id
  	  flash[:success] = "you have successfully created a job description"
  	  redirect_to [@company, @job_description]
  	else
  	  flash.now[:alert] = "oops! sthg went wrong"
  	  render :new
  	end
  end

  def edit
  end

  def update
  	if @job_description.update(job_params)
  	  @job_description.update(update_button: false)	
  	  flash[:success] = "you successfully updated job description"
  	  if request.referrer == edit_company_job_description_url(@company, @job_description)
        redirect_to [@company, @job_description]
      else
        redirect_to :back 
      end
  	else
  	  flash.now[:alert] = "oops! sthg went wrong"
  	  redirect_to :back
  	end
  end

  def destroy
    @job_description.destroy
    redirect_to :back
  end

  def update_button
  	@job_description = JobDescription.find(params[:id])
  	@job_description.update(update_button: true)
  	redirect_to company_url(@job_description.company, tab: "job descriptions") + "#job descriptions"
  end


  private

  def set_company
  	@company = Company.find(params[:company_id])
  end

  def set_job_description
  	set_company
  	@job_description = @company.job_descriptions.find(params[:id])
  end

  def job_params
  	params.require(:job_description).permit(:job_title, :experience, :min_salary, :max_salary, :vacancies, :update_button)
  end
end
