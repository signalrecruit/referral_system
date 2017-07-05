class Admin::JobDescriptionsController < Admin::ApplicationController
  before_action :set_company, except: [:update_button, :index]
  before_action :set_job_description, only: [:show, :edit, :update, :destroy]
  layout "admin"

  def index
    @all_roles = JobDescription.all.order(created_at: :asc)
  end

  def show
  end

  def edit
  end

  def update
  	if @job_description.update(job_params)
      @job_description.update_applicants_salary
      @job_description.calculate_jd_actual_worth
      @job_description.earning_algorithm
  	  @job_description.update(update_button: false)	
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
    @owner_id = params[:edit_owner_id] if @owner_id.nil?
  	@job_description = JobDescription.find(params[:id])
    if @job_description.update_button == true 
      flash[:alert] = "this action is not possible. this role is being worked on currently"
      redirect_to :back
    else   
  	  @job_description.update(update_button: true)
  	  redirect_to admin_company_url(@job_description.company, tab: "job descriptions", si: @owner_id) + "#job descriptions"
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
  	params.require(:job_description).permit(:job_title, :experience, :min_salary, :max_salary, :vacancies, :update_button, :potential_worth, :actual_worth, :percent_worth, :applicant_worth,
     :applicant_percent_worth, :earnings, :vacancy_worth, :vacancy_percent_worth)
  end
end
