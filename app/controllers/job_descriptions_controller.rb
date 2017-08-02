class JobDescriptionsController < ApplicationController
  before_action :authenticate_user!
  before_action :copy_changes_to_existing_object, only: [:update]
  before_action :set_company, except: [:update_button, :complete_job_description, :update_job_description, :copy_changes_to_existing_object]
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
      JobDescriptionSubServicesAfterCreate.new({ job_description: @job_description, current_user: current_user }).initiate_sub_services
      track_activity @job_description, params[:action], current_user.id if @job_description.completed?
      # find company and find if it has a role or any user tied to it. Then create a role on this jd for the user if no role found for this jd
      create_role_for @job_description
      on_success "you have successfully created a job description", new_job_description_qualification_url(@job_description)
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
      JobDescriptionSubServicesAfterUpdate.new({ job_description: @job_description }).initiate_sub_services     
  	  flash[:success] = "you successfully updated job description"
  	  if request.referrer == edit_company_job_description_url(@company, @job_description)
        redirect_to [@company, @job_description]
      else
        redirect_to :back 
      end
  	else
      on_failure "oops! sthg went wrong", :back
  	end
  end

  def destroy
    if @job_description.applicants.any?
      on_caution "can't proceed with this action. this job description has associated applicants. please contact the admin for help with this.", :back
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
      CompleteJobDescriptionService.new({ job_description: @job_description }).complete_jd
      JobDescriptionCreateNotificationService.new( {actor: current_user, action: "posted", resource: @job_description, resource_type: @job_description.class.name} ).notify_admins_and_users
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

  def create_role_for(job_description)
    @company = job_description.company 
    if role = Role.find_by(role: "owner", resource_id: @company.id, resource_type: @company.class.name) 
      Role.create role: "owner", user_id: role.user_id, resource_id: job_description.id, resource_type: job_description.class.name
    end
  end

  def copy_changes_to_existing_object
    @job_description = JobDescription.find(params[:id])
    if @job_description.applicants.any?
      if jd_copy = JobDescription.find_by(copy: true, copy_id: @job_description.id)
        jd_copy.attachments.delete_all 
        jd_copy.delete
        @jd_copy = JobDescription.new
        job_description_copy_attributes = job_params
        job_description_copy_attributes.delete("id")
        job_description_copy_attributes["copy"] = true 
        job_description_copy_attributes["copy_id"] = @job_description.id
        job_description_copy_attributes.delete("attachments_attributes")
        job_description_copy_attributes["update_button"] = false
        job_description_copy_attributes["user_id"] = @job_description.user_id 
        job_description_copy_attributes["company_id"] = @job_description.company_id
        job_description_copy_attributes["number_of_applicants"] = @job_description.number_of_applicants
        @job_description.attachments.each do |attachment|
          @jd_copy.attachments << Attachment.create(file: params["job_description"]["attachments_attributes"]["0"]["file"], job_description_id: @jd_copy.id, copy: true, copy_id: attachment.id)
        end
        @jd_copy.update_attributes job_description_copy_attributes
      else
        @jd_copy = JobDescription.new
        job_description_copy_attributes = job_params
        job_description_copy_attributes.delete("id")
        job_description_copy_attributes["copy"] = true 
        job_description_copy_attributes["copy_id"] = @job_description.id
        job_description_copy_attributes.delete("attachments_attributes")
        job_description_copy_attributes["update_button"] = false
        job_description_copy_attributes["user_id"] = @job_description.user_id 
        job_description_copy_attributes["company_id"] = @job_description.company_id
        job_description_copy_attributes["number_of_applicants"] = @job_description.number_of_applicants
        @job_description.attachments.each do |attachment|
          @jd_copy.attachments << Attachment.create(file: params["job_description"]["attachments_attributes"]["0"]["file"], job_description_id: @jd_copy.id, copy: true, copy_id: attachment.id)
        end
        @jd_copy.update_attributes job_description_copy_attributes
      end
      @job_description.update(update_button: false) 
      # JobDescriptionUpdateNotificationService.new({ actor: current_user, action: "pending update", resource: @job_description, resource_type: @job_description.class.name }).notify_admin
      # flash[:alert] = "your update has been saved. but will only reflect on admins authorization"
      redirect_to company_job_description_url @job_description.company, @job_description
    end
  end
end
