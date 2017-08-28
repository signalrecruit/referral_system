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

    if flash[:alert].nil?
      flash.now[:warning] = "Hi #{current_user.fullname}. The role #{@job_description.job_title} is incomplete. Complete the form." unless @job_description.completed?
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
      if job_description_has_a_copy?
        flash[:success] = "your changes have been saved pending admin approval."
      else   
        flash[:success] = "you have successfully completed the job description for the role #{@job_description.job_title}"
      end
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
    existing_attributes = @job_description.attributes 
    update_attributes = job_params
    # byebug
    sanitize_attributes_for_comparison existing_attributes, update_attributes

    if change_in_data @existing_attributes, @update_attributes
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

          if params["job_description"]["attachments_attributes"]["0"]["file"].nil?
            @job_description.attachments.each do |attachment|
              @jd_copy.attachments << Attachment.create(file: @job_description.attachments.first.file, job_description_id: @jd_copy.id, copy: true, copy_id: attachment.id)
            end          
          else
            @job_description.attachments.each do |attachment|
              @jd_copy.attachments << Attachment.create(file: params["job_description"]["attachments_attributes"]["0"]["file"], job_description_id: @jd_copy.id, copy: true, copy_id: attachment.id)
            end
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

         if params["job_description"]["attachments_attributes"]["0"]["file"].nil?
            @job_description.attachments.each do |attachment|
              @jd_copy.attachments << Attachment.create(file: @job_description.attachments.first.file, job_description_id: @jd_copy.id, copy: true, copy_id: attachment.id)
            end          
          else
            @job_description.attachments.each do |attachment|
              @jd_copy.attachments << Attachment.create(file: params["job_description"]["attachments_attributes"]["0"]["file"], job_description_id: @jd_copy.id, copy: true, copy_id: attachment.id)
            end
          end

          @jd_copy.update_attributes job_description_copy_attributes
        end
        @job_description.update(update_button: false) 
        JobDescriptionUpdateNotificationService.new({ actor: current_user, action: "pending update", resource: @job_description, resource_type: @job_description.class.name }).notify_admin
        flash[:alert] = "your update has been saved. but will only reflect on admins authorization"
        redirect_to company_job_description_url @job_description.company, @job_description
      end
    else
      @job_description.update update_button: false
      flash[:alert] = "no changes detected"
      redirect_to :back
    end
  end

  def sanitize_attributes_for_comparison existing_attributes, update_attributes
    ["id", "company_id", "created_at", "updated_at", "user_id", "status", "earnings", "salary", "update_button", "number_of_applicants", "actual_worth", "percent_worth", "user_id", "applicant_worth", "applicant_percent_worth", "vacancy_worth",
      "vacancy_percent_worth", "earnings", "potential_worth", "completed", "vacancies_filled", "edit_user_id", "update_salary", "percent_salary", "update_salary_button", "copy", "copy_id" ].each do |key|
      existing_attributes.delete(key)  
    end
    update_attributes["min_salary"] = update_attributes["min_salary"].to_f
    update_attributes["max_salary"] = update_attributes["max_salary"].to_f 
    update_attributes["experience"] = update_attributes["experience"].to_i
    update_attributes["vacancies"] = update_attributes["vacancies"].to_i
    update_attributes["expiration_date"] =  DateTime.new(update_attributes["expiration_date(1i)"].to_i, update_attributes["expiration_date(2i)"].to_i, update_attributes["expiration_date(3i)"].to_i, update_attributes["expiration_date(4i)"].to_i, 
    update_attributes["expiration_date(5i)"].to_i)
    
    ["expiration_date(1i)", "expiration_date(2i)", "expiration_date(3i)", "expiration_date(4i)", "expiration_date(5i)" ].each do |key|
      update_attributes.delete(key)
    end
    
    attachment_attributes = job_params["attachments_attributes"]
    if job_params["attachments_attributes"]["0"]["file"].nil?
      update_attributes.delete("attachments_attributes")
    else
      attachment_attributes[0] = { "file" => job_params["attachments_attributes"]["0"]["file"].original_filename } 
    end

  
    @existing_attributes = existing_attributes 
    @update_attributes = update_attributes
  end

  def job_description_has_a_copy?
    JobDescription.find_by(copy: true, copy_id: @job_description.id) || @job_description.
    qualifications.find_by(copy: true) || @job_description.required_experiences.find_by(copy: true) || @job_description.requirements.find_by(copy: true)
  end
end
