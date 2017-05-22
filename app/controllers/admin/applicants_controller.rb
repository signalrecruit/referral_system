class Admin::ApplicantsController < Admin::ApplicationController
  before_action :set_jd, except: [:update_salary]
  before_action :set_applicant, only: [:show, :update]	
  layout "admin"
  	
  def index
  	@applicants = @jd.applicants.all
  end

  def show
  end

  def update
    if @applicant.update(applicant_params)
      @applicant.update(update_button: false, update_salary_button: false)   
      @applicant.update_salary
      @applicant.job_description.calculate_jd_actual_worth

      flash[:success] = "you successfully updated this applicant"

      if request.referrer == (edit_job_description_applicant_url(@jd, @applicant) || job_description_applicants_url(@jd))
        redirect_to [@jd, @applicant]
      else
        redirect_to :back
      end
      @jd.earning_algorithm
      @applicant.pay_user_when_applicant_is_hired
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
       :max_salary, :company_id, :job_description_id, :user_id, :attachment, :update_button, :status, :salary, :update_salary_button)
  end
end
