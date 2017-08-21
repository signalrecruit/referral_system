class Admin::ApplicantsController < Admin::ApplicationController
  before_action :set_admin_authorization_parameters, only: [:update_button, :update, :destroy, :shortlist, :interviewing, :testing, :salary_negotiation, :hire, :unhire, :allow_changes_to_applicant]
  before_action :set_jd, except: [:update_salary, :update_button, :all_applicants, :shortlist, :interviewing, :testing, :salary_negotiation, :hire, :unhire, :allow_changes_to_applicant]
  before_action :set_applicant, only: [:show, :update]	
  before_action :vacancy_vs_hired_applicants_check, only: [:hire]
  before_action :response_to_clicking_the_same_action, only: [:testing, :shortlist, :interviewing, :salary_negotiation, :hire, :unhire]
  after_action :update_applicant_record, only: [:testing, :shortlist, :interviewing, :salary_negotiation, :hire, :unhire]
  layout "admin"
  
  # REFACTORING NOTE: refactor not-resource public actions into a separate controller 
  def index
  	@applicants = @jd.applicants.where(copy: false).all.order(created_at: :asc)
  end

  def show
    @applicant_copy = if applicant_copy = Applicant.find_by(copy: true, copy_id: @applicant.id)
                  applicant_copy
                end     
  end

  def update
    if @applicant.update(applicant_params)
      @applicant.update(update_button: false, update_salary_button: false)   
      @applicant.update_salary
      @applicant.job_description.calculate_jd_actual_worth
      flash[:success] = "you successfully updated this applicant"

      if request.referrer == edit_job_description_applicant_url(@jd, @applicant) || request.referrer == job_description_applicants_url(@jd)
        redirect_to [@jd, @applicant]
      else
        @applicant.not_hired? ? "#{redirect_to new_admin_applicant_comment_url(@applicant)}" : "#{redirect_to :back}"
        @applicant.update_applicant_history @jd
      end
      @jd.earning_algorithm
      @applicant.pay_user_when_applicant_is_hired
      track_applicant_hiring_status
    else
      flash.now[:alert] = "oops! something went wrong"
      render :edit
    end
  end

  def update_salary
    @applicant = Applicant.find(params[:id])
    @applicant.update(update_salary_button: true)
    redirect_to :back
  end

  def update_button
    @applicant = Applicant.find(params[:id])
    @applicant.update(update_button: true)
    redirect_to :back
  end

  def interviewing
    @applicant = Applicant.find(params[:id])
    @applicant.update(status: "interviewing")
    ApplicantStatusNotificationService.new({ recipient: @applicant.user, actor: current_user, action: @applicant.status, resource: @applicant, resource_type: @applicant.class.name }).notify_user
    redirect_to :back
  end

  def testing 
    @applicant = Applicant.find(params[:id])
    @applicant.update(status: "testing")
    ApplicantStatusNotificationService.new({ recipient: @applicant.user, actor: current_user, action: @applicant.status, resource: @applicant, resource_type: @applicant.class.name }).notify_user
    redirect_to :back
  end

  def shortlist 
    @applicant = Applicant.find(params[:id])
    @applicant.update(status: "shortlisted")
    ApplicantStatusNotificationService.new({ recipient: @applicant.user, actor: current_user, action: @applicant.status, resource: @applicant, resource_type: @applicant.class.name }).notify_user
    redirect_to :back
  end

  def salary_negotiation
    @applicant = Applicant.find(params[:id])
    @applicant.update(status: "salary negotiation")
    ApplicantStatusNotificationService.new({ recipient: @applicant.user, actor: current_user, action: @applicant.status, resource: @applicant, resource_type: @applicant.class.name }).notify_user
    redirect_to :back
  end

  def hire
    @applicant = Applicant.find(params[:id])
    if @applicant.job_description.percent_worth.to_f != 0.0 && @applicant.job_description.vacancy_percent_worth.to_f != 0.0
      @applicant.update(status: "hired")
      ApplicantStatusNotificationService.new({ recipient: @applicant.user, actor: current_user, action: @applicant.status, resource: @applicant, resource_type: @applicant.class.name }).notify_user
      @applicant.job_description.earning_algorithm
      @applicant.pay_user_when_applicant_is_hired
      track_activity @applicant, "hired", @applicant.user
      redirect_to :back 
    else 
      @applicant.job_description.update(update_button: true, edit_user_id: current_user.id)
      flash[:alert] = "please fill in non-zero values in order to proceed with hiring #{@applicant.name}"
      redirect_to [:admin, @applicant.company, tab: "job descriptions", applicant_id: @applicant.id]
    end
  end

  def unhire 
    @applicant = Applicant.find(params[:id])
    @applicant.update(status: "not hired")
    ApplicantStatusNotificationService.new({ recipient: @applicant.user, actor: current_user, action: @applicant.status, resource: @applicant, resource_type: @applicant.class.name }).notify_user
    @applicant.job_description.earning_algorithm
    @applicant.pay_user_when_applicant_is_hired
    track_activity @applicant, "not hired", @applicant.user 
    redirect_to :back
  end

  def all_applicants
    @all_applicants = Applicant.all.includes(:company).where(copy: false).all.order(created_at: :asc)
    @applicant_id = params[:applicant_id].to_i
  end

  def allow_changes_to_applicant
    @applicant = @applicant = Applicant.find(params[:id])
    @applicant_copy = if applicant_copy = Applicant.find_by(copy: true, copy_id: @applicant.id)
                        applicant_copy 
                      end 

    if (@applicant.email != @applicant_copy.email) || (@applicant.phonenumber != @applicant_copy.phonenumber) || (@applicant.location != @applicant_copy
      .location) || (@applicant.cv != @applicant_copy.cv) || (@applicant.min_salary != @applicant_copy.min_salary) || (@applicant.max_salary != @applicant_copy
      .max_salary)
      
      @applicant_copy.requirement_scores.each do |req_score_copy|
        original_req_score = RequirementScore.find_by(id: req_score_copy.copy_id)
        if original_req_score
          if original_req_score.id == req_score_copy.copy_id 
            original_req_score.update(score: req_score_copy.score)
          end
        end  
      end
      
      @applicant.update(name: @applicant_copy.name, email: @applicant_copy.email, phonenumber: @applicant_copy.phonenumber, location: @applicant_copy.location, min_salary: @applicant_copy.min_salary, max_salary: @applicant_copy.max_salary,
         cv: @applicant_copy.cv) 
      ApplicantSubServicesAfterUpdate.new({ applicant: @applicant, jd: @applicant.job_description }).initiate_sub_services
      @applicant_copy.requirement_scores.delete_all
      @applicant_copy.delete 
      AuthorizeApplicantUpdateNotificationService.new({ actor: current_user, action: "authorize", resource: @applicant, resource_type: @applicant.class.name }).notify_user
      flash[:success] = "changes have been incorporated." 
    end
    redirect_to :back
  end



  private

  def response_to_clicking_the_same_action
    @applicant = Applicant.find(params[:id])
    @job_description = @applicant.job_description
    if (params[:action] == "shortlist" && @applicant.shortlisted?) || (params[:action] == "interviewing" && @applicant.interviewing?) || (params[:action] == "testing" && @applicant.testing?) || (
      params[:action] == "salary_negotiation" && @applicant.salary_negotiation?) || (params[:action] == "hire" && @applicant.hired?) || (params[:action] == "unhire" && @applicant.not_hired?)
      flash[:alert] = "already selected this action"
      redirect_to :back  
    end
  end

  def vacancy_vs_hired_applicants_check
    @applicant = Applicant.find(params[:id])
    @job_description = @applicant.job_description
    if @job_description.vacancies == @job_description.applicants.where(status: "hired").count 
      flash[:alert] = "can't proceed to process #{@applicant.name} because the number of vacancies has been filled with
       hired applicants"
      redirect_to :back
    end
  end

  def track_applicant_hiring_status
    if @applicant.hired?
      if activity_exists? @applicant.id, "Applicant"
        @activity.update(action: @applicant.status)
      else
       track_activity @applicant, "hired", current_user.id
      end 
    elsif @applicant.not_hired? 
      if activity_exists? @applicant.id, "Applicant"
        @activity.update(action: @applicant.status)
      else
        track_activity @applicant, "not hired", current_user.id 
      end
    end
  end

  def set_jd
  	@jd = JobDescription.find(params[:job_description_id])
  end

  def set_applicant
  	set_jd 
  	@applicant = @jd.applicants.find(params[:id])
  end

  def applicant_params
    params.require(:applicant).permit(:name, :email, :phonenumber, :location, :min_salary, :cv, :cv_cache,
       :max_salary, :company_id, :job_description_id, :user_id, :attachment, :update_button, :status, :salary, :update_salary_button)
  end

  def set_admin_authorization_parameters
    @applicant = Applicant.find(params[:id])
    Authorization::AdminAuthorizationPolicy.new(current_user, @applicant, @applicant.class.name, self).implement_authorization_policy
  end

  def update_applicant_record
    @applicant.update_applicant_history @applicant.job_description
  end
end
