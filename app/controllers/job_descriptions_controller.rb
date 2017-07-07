class JobDescriptionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_company, except: [:update_button, :complete_job_description, :update_job_description]
  before_action :set_job_description, only: [:show, :edit, :update, :destroy]


  def index
  end

  def show
    if @job_description.attachments.empty?
      @job_description.attachments.build 
    else 
      @job_description.attachments  
    end
  end

  def new
  	@job_description = @company.job_descriptions.build
    @job_description.attachments.build 
  end
  
  def create
  	@job_description = @company.job_descriptions.build(job_params)

  	if @job_description.save 
      @job_description.update(user_id: current_user.id)
      track_activity @job_description, params[:action], current_user.id if @job_description.completed?
      @job_description.update_applicants_salary
  	  flash[:success] = "you have successfully created a job description"
  	  redirect_to new_job_description_qualification_url(@job_description)
  	else
  	  flash.now[:alert] = "oops! sthg went wrong"
      @job_description.attachments.build if @job_description.attachments.empty?
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
    if @job_description.applicants.any?
      flash[:alert] = "can't proceed with this action. this job description has associated applicants. please contact the admin for help with this."
      redirect_to :back 
    else  
      @job_description.remove_related_activities_from_newsfeed
      redirect_to :back
    end
  end

  def update_button
  	@job_description = JobDescription.find(params[:id])
  	@job_description.update(update_button: true)
    redirect_to :back
  end

  def complete_job_description
    if jd_completed?
      @job_description = JobDescription.find(params[:id])
      @job_description.update(completed: true)
      @job_description.update_jd_status
      track_activity @job_description, "create", current_user.id if !activity_exists? @job_description.id, "JobDescription", "create"
      flash[:success] = "you have successfully completed the job description for the role #{@job_description.job_title}"
    else
      flash[:alert] = "this job description lacks info under either Required Qualifications, Required Experiences, and/or Compulsory Requirements"
    end
    redirect_to :back
  end

  def update_job_description
    @job_description = JobDescription.find(params[:id])
    @job_description.update(completed: false)
    if request.referrer == company_url(@job_description.company, tab: "job descriptions")
      redirect_to [@job_description.company, @job_description]
    else
      redirect_to :back
    end
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
  	params.require(:job_description).permit(:job_title, :role_description, :experience, :min_salary, :max_salary, :vacancies, :update_button,
     :completed, :expiration_date, attachments_attributes: [:id, :file, :file_cache, :_destroy])
  end

  def jd_completed?
    @job_description = JobDescription.find(params[:id])
    @job_description.qualifications.any? && @job_description.required_experiences.any? && @job_description.requirements.any?
  end
end
