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
    @jd.requirements.count.times { @applicant.requirement_scores.build }  
    @applicant.requirement_scores.each do |score|
      score.requirement_content = @jd.requirements[@count].content
      score.requirement_id = @jd.requirements[@count].id
      score.job_description_id = @jd.id
      @count += 1
    end 
  end

  def create
  	@applicant = @jd.applicants.build(applicant_params)


  	if @applicant.save 
  	  @applicant.update(company_id: @jd.company.id)	
  	  track_activity @applicant, "added an applicant", current_user.id	
  	  @applicant.update(user_id: current_user.id)	
      @applicant.calculate_applicant_score
      @applicant.record_applicant_history @jd
      @applicant.job_description.update_jd_status
      @applicant.update_salary
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
      @applicant.calculate_applicant_score
      @applicant.update_applicant_history @jd
  	  flash[:success] = "you successfully updated this applicant"

      if request.referrer == edit_job_description_applicant_url(@jd, @applicant) || request.referrer == job_description_applicants_url(@jd)
        redirect_to [@jd, @applicant]
      else
  	    redirect_to :back
      end
  	else
  	  flash.now[:alert] = "oops! something went wrong"
  	  render :edit
  	end
  end

  def destroy
  	@applicant.remove_related_activities_from_newsfeed
  	flash[:success] = "deletion successful"
  	# redirect_to job_description_applicants_url(@jd)
    redirect_to :back
  end

  def update_button
  	@applicant = Applicant.find(params[:id])
    if @applicant.interviewing? || @applicant.testing? || @applicant.salary_negotiation? || @applicant.hired?
      flash[:alert] = "not possible to edit #{@applicant.name}'s detail now.  #{@applicant.name} is currently #{@applicant.status}.
      Please contact admin for help with this." 
      redirect_to new_message_url(reply_id: 0)
  	else
      @applicant.update(update_button: true)
  	  redirect_to [:edit, @applicant.job_description, @applicant]
    end
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
  		 :max_salary, :cv, :company_id, :job_description_id, :user_id, :attachment, :update_button,
        requirement_scores_attributes: [:id, :score, :requirement_content, :requirement_id, :job_description_id, :_destroy])
  end
end
