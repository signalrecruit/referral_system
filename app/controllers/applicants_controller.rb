class ApplicantsController < ApplicationController
  before_action :authenticate_user!
  before_action :copy_changes_to_existing_object, only: [:update]
  before_action :set_jd, except: [:update_button]
  before_action :set_applicant, only: [:show, :edit, :update, :destroy]

  def index
  	@applicants = @jd.applicants.all
    fresh_when last_modified: @applicants.maximum(:updated_at)
  end

  def show
  end

  def new
    @count = 0
  	@applicant = @jd.applicants.build
    BuildApplicantScoreService.new({ applicant: @applicant, jd: @jd, count: @count }).build_score
  end

  def create
  	@applicant = @jd.applicants.build(applicant_params)

  	if @applicant.save  	  	
  	  track_activity @applicant, "added an applicant", current_user.id	
      ApplicantSubServicesAfterCreate.new({ applicant: @applicant, jd: @jd, current_user: current_user }).initiate_sub_services
      ApplicantCreateNotificationService.new({ actor: current_user, action: "created", resource: @applicant, resource_type: "Applicant" }).notify_admins_and_users
      on_success "you successfully added an applicant to this job description", [@jd, @applicant]
  	else
      on_failure "oops! something went wrong", :new
  	end
  end

  def edit
  end

  def update
  	if @applicant.update(applicant_params)
  	  ApplicantSubServicesAfterUpdate.new({ applicant: @applicant, jd: @jd }).initiate_sub_services
  	  flash[:success] = "you successfully updated this applicant"

      if request.referrer == edit_job_description_applicant_url(@jd, @applicant) || request.referrer == job_description_applicants_url(@jd)
        redirect_to [@jd, @applicant]
      else
  	    redirect_to :back
      end
  	else
      on_failure "oops! something went wrong", :edit
  	end
  end

  def destroy
  	@applicant.remove_related_activities_from_newsfeed
    on_success "deletion successful", :back
  end

  def update_button
  	@applicant = Applicant.find(params[:id])
    # if @applicant.interviewing? || @applicant.testing? || @applicant.salary_negotiation? || @applicant.hired?
      # on_caution "not possible to edit #{@applicant.name}'s detail now.  #{@applicant.name} is currently #{@applicant.status}.
      # Please contact admin for help with this.", new_message_url(reply_id: 0)
      # redirect_to [:edit, @applicant.job_description, @applicant]
  	# else
      @applicant.update(update_button: true)
  	  redirect_to [:edit, @applicant.job_description, @applicant]
    # end
  end


  private 
  
  def set_jd
  	@jd = JobDescription.find(params[:job_description_id])
  end

  def set_applicant
  	set_jd 
  	@applicant = @jd.applicants.find(params[:id])
    fresh_when @applicant
  end

  def applicant_params
  	params.require(:applicant).permit(:name, :email, :phonenumber, :location, :min_salary,
  		 :max_salary, :cv, :cv_cache, :company_id, :job_description_id, :user_id, :attachment, :update_button,
        requirement_scores_attributes: [:id, :score, :requirement_content, :requirement_id, :job_description_id, :_destroy])
  end

  def copy_changes_to_existing_object
    @applicant = Applicant.find(params[:id])

    existing_attributes = @applicant.attributes 
    update_attributes = applicant_params
    sanitize_attributes_for_comparison existing_attributes, update_attributes

    if change_in_data @existing_attributes, @update_attributes
      if applicant_copy = Applicant.find_by(copy: true, copy_id: @applicant.id)
        applicant_copy.requirement_scores.delete_all
        applicant_copy.delete 

        # byebug
        @applicant_copy = Applicant.new(copy: true, copy_id: @applicant.id, update_button: false, user_id: @applicant.user_id, company_id: @applicant.company_id,
         job_description_id: @applicant.job_description_id,
          update_salary_button: false, percent_salary: @applicant.percent_salary, salary: @applicant.salary, earnings: @applicant.earnings, status: @applicant.status)
       

        applicant_params["requirement_scores_attributes"].each do |key, value|
          req_score_copy = RequirementScore.find_by(copy: true, copy_id: value["id"].to_i)
          req_score_copy.delete if req_score_copy 
          @applicant_copy.requirement_scores << RequirementScore.create(score: value["score"].to_f, applicant_id: @applicant_copy.id, requirement_id: value["id"].to_i, 
            requirement_content: Requirement.find(value["id"].to_i).content, job_description_id: @applicant.job_description_id, copy: true, copy_id: value["id"].to_i)  
        end
        @applicant_copy.save

        applicant_copy_attributes = applicant_params
        ["copy", "copy_id", "update_button", "user_id", "company_id", "update_salary_button", "percent_salary", "salary", "earnings", "status", "requirement_scores_attributes"].each do |key|
          applicant_copy_attributes.delete(key)
        end

        if applicant_copy_attributes["cv"].present?  
          @applicant_copy.update_attributes applicant_copy_attributes
        else
          applicant_copy_attributes["cv"] = @applicant.cv 
          @applicant_copy.update_attributes applicant_copy_attributes
        end
      else 
        @applicant_copy = Applicant.new(copy: true, copy_id: @applicant.id, update_button: false, user_id: @applicant.user_id, company_id: @applicant.company_id,
         job_description_id: @applicant.job_description_id,
          update_salary_button: false, percent_salary: @applicant.percent_salary, salary: @applicant.salary, earnings: @applicant.earnings, status: @applicant.status)
       
        # byebug
        applicant_params["requirement_scores_attributes"].each do |key, value|
          req_score_copy = RequirementScore.find_by(copy: true, copy_id: value["id"].to_i)
          req_score_copy.delete if req_score_copy 
          @applicant_copy.requirement_scores << RequirementScore.create(score: value["score"].to_f, applicant_id: @applicant_copy.id, requirement_id: RequirementScore.find(value["id"].to_i).requirement_id, 
            requirement_content: Requirement.find(RequirementScore.find(value["id"].to_i).requirement_id).content, job_description_id: @applicant.job_description_id, copy: true, copy_id: value["id"].to_i)  
        end
        @applicant_copy.save

        applicant_copy_attributes = applicant_params
        ["copy", "copy_id", "update_button", "user_id", "company_id", "update_salary_button", "percent_salary", "salary", "earnings", "status", "requirement_scores_attributes"].each do |key|
          applicant_copy_attributes.delete(key)
        end

        
        if applicant_copy_attributes["cv"].present?  
          @applicant_copy.update_attributes applicant_copy_attributes
        else
          applicant_copy_attributes["cv"] = @applicant.cv 
          @applicant_copy.update_attributes applicant_copy_attributes
        end
      end
        ApplicantUpdateNotificationService.new({ actor: current_user, action: "pending update", resource: @applicant, resource_type: @applicant.class.name }).notify_admin
        flash[:success] = "your updates have been saved pending admin authorization"
        redirect_to [@applicant.job_description, @applicant]
    else
      flash[:alert] = "no changes detected"
      redirect_to :back
    end
  end

  def sanitize_attributes_for_comparison existing_attributes, update_attributes
    ["id", "company_id", "job_description_id", "created_at", "updated_at", "user_id", "status", "earnings", "salary", "update_button",
     "update_salary", "percent_salary", "update_salary_button", "copy", "copy_id" ].each do |key|
      existing_attributes.delete(key)  
    end
    update_attributes["min_salary"] = update_attributes["min_salary"].to_i 
    update_attributes["max_salary"] = update_attributes["max_salary"].to_i 

    # update_attributes.delete("requirement_scores_attributes")  
    # re-create requirement scores attributes
    @c = 0
    requirement_scores_attributes = HashWithIndifferentAccess.new
    @applicant.requirement_scores.each do |req_score|
      requirement_scores_attributes["#{@c}"] = { "id" => "#{req_score.id}" , "score" => "#{req_score.score}" }
      @c += 1
    end
    existing_attributes["requirement_scores_attributes"] = requirement_scores_attributes
    update_attributes.delete("cv_cache")
    
    if applicant_params["cv"]
      update_attributes["cv"] = applicant_params["cv"].original_filename
    else
      existing_attributes.delete("cv")
    end
    @existing_attributes = existing_attributes 
    @update_attributes = update_attributes
  end
end
