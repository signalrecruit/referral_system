class Admin::ApplicantsController < Admin::ApplicationController
  before_action :set_admin_authorization_parameters, only: [:update_button, :update, :destroy, :shortlist, :interviewing, :testing, :salary_negotiation, :hire, :unhire, :allow_changes_to_applicant]
  before_action :set_jd, except: [:update_salary, :update_button, :all_applicants, :shortlist, :interviewing, :testing, :salary_negotiation, :hire, :unhire]
  before_action :set_applicant, only: [:show, :update]	
  layout "admin"
  	
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
    if @applicant.job_description.percent_worth.to_f != 0.0 && @applicant.job_description.actual_worth.to_f != 0.0 && @applicant.job_description.vacancy_percent_worth.to_f != 0.0
      @applicant.update(status: "hired")
      ApplicantStatusNotificationService.new({ recipient: @applicant.user, actor: current_user, action: @applicant.status, resource: @applicant, resource_type: @applicant.class.name }).notify_user
      @applicant.job_description.earning_algorithm
      @applicant.pay_user_when_applicant_is_hired
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
    redirect_to :back
  end

  def all_applicants
    @all_applicants = Applicant.where(copy: false).all.order(created_at: :asc)
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
      applicant_copy_attributes = @applicant_copy.attributes 
      applicant_copy_attributes.delete("id")
      applicant_copy_attributes["copy"] = false 
      applicant_copy_attributes["copy_id"] = nil 
      @applicant.update(applicant_copy_attributes)
      @applicant_copy.delete 
      AuthorizeApplicantUpdateNotificationService.new({ actor: current_user, action: "authorize", resource: @applicant, resource_type: @applicant.class.name }).notify_user
      flash[:success] = "changes have been incorporated." 
    end
    redirect_to :back
  end



  private

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
    params.require(:applicant).permit(:name, :email, :phonenumber, :location, :min_salary,
       :max_salary, :company_id, :job_description_id, :user_id, :attachment, :update_button, :status, :salary, :update_salary_button)
  end

  def set_admin_authorization_parameters
    @applicant = Applicant.find(params[:id])
    Authorization::AdminAuthorizationPolicy.new(current_user, @applicant, @applicant.class.name, self).implement_authorization_policy
  end
end
