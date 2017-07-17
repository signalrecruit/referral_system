class ApplicantsController < ApplicationController
  before_action :authenticate_user!
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
    build_applicant_score_service
  end

  def create
  	@applicant = @jd.applicants.build(applicant_params)

  	if @applicant.save  	  	
  	  track_activity @applicant, "added an applicant", current_user.id	
      initiate_applicant_sub_services_after_create
      on_success "you successfully added an applicant to this job description", [@jd, @applicant]
  	else
      on_failure "oops! something went wrong", :new
  	end
  end

  def edit
  end

  def update
  	if @applicant.update(applicant_params)
  	  initiate_applicant_sub_services_after_update 
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
    if @applicant.interviewing? || @applicant.testing? || @applicant.salary_negotiation? || @applicant.hired?
      on_caution "not possible to edit #{@applicant.name}'s detail now.  #{@applicant.name} is currently #{@applicant.status}.
      Please contact admin for help with this.", new_message_url(reply_id: 0)
  	else
      @applicant.update(update_button: true)
  	  redirect_to [:edit, @applicant.job_description, @applicant]
    end
  end


  private 
  # applicant services
  def build_applicant_score_service
    BuildApplicantScoreService.new({ applicant: @applicant, jd: @jd, count: @count }).build_score
  end

  def initiate_applicant_sub_services_after_create
    ApplicantSubServicesAfterCreate.new({ applicant: @applicant, jd: @jd, current_user: current_user }).initiate_sub_services
  end

  def initiate_applicant_sub_services_after_update 
    ApplicantSubServicesAfterUpdate.new({ applicant: @applicant, jd: @jd }).initiate_sub_services
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
  		 :max_salary, :cv, :cv_cache, :company_id, :job_description_id, :user_id, :attachment, :update_button,
        requirement_scores_attributes: [:id, :score, :requirement_content, :requirement_id, :job_description_id, :_destroy])
  end
end
