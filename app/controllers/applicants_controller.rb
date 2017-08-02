class ApplicantsController < ApplicationController
  before_action :authenticate_user!
  before_action :copy_changes_to_existing_object, only: [:update]
  before_action :set_jd, except: [:update_button]
  before_action :set_applicant, only: [:show, :edit, :update, :destroy]

  def index
  	@applicants = @jd.applicants.all
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
      else 
      end
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
      update_attributes["cv"] = applicant_params["cv"].filename
    else
      existing_attributes.delete("cv")
    end
    @existing_attributes = existing_attributes 
    @update_attributes = update_attributes
  end
end
