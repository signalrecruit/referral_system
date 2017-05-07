class Admin::JobDescriptionsController < Admin::ApplicationController
  before_action :set_company, except: [:update_button]
  before_action :set_job_description, only: [:show, :edit, :update, :destroy]
  layout "admin"

  def index
  end

  def show
  end

  def edit
  end

  def update
  	if @job_description.update(job_params)
  	  @job_description.update(update_button: false)	

      update_payment_to_users

  	  flash[:success] = "you successfully updated job description"
  	  redirect_to :back
  	else
  	  flash.now[:alert] = "oops! sthg went wrong"
  	  redirect_to :back
  	end
  end

  def destroy
    @job_description.destroy
    redirect_to :back
  end

  def update_button
  	@job_description = JobDescription.find(params[:id])
  	@job_description.update(update_button: true)
  	redirect_to admin_company_url(@job_description.company, tab: "job descriptions") + "#job descriptions"
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
  	params.require(:job_description).permit(:job_title, :experience, :min_salary, :max_salary, :vacancies, :update_button, :worth, :percent_worth, :earnings)
  end

  def update_payment_to_users
    @job_description.applicants.each do |applicant|
      applicant.if_hired_pay_users
    end
  end

end
