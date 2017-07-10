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
      # @job_description.update_applicants_salary
      # @job_description.calculate_jd_actual_worth
      @job_description.earning_algorithm
  	  @job_description.update(update_button: false, edit_user_id: nil)	
       
      # please Derek, you know better than not to refactor this piece of shit! 
      if !params[:job_description][:applicant_id].blank?
        if @job_description.potential_worth.to_f != 0.0 && @job_description.percent_worth.to_f != 0.0 && @job_description.vacancy_percent_worth.to_f != 0.0
  	      flash[:success] = "you successfully updated job description, #{(Applicant.find(params[:job_description][:applicant_id].to_i)).name} is hired!"
          Applicant.find(params[:job_description][:applicant_id].to_i).update(status: "hired") if !params[:job_description][:applicant_id].blank?
  	      redirect_to admin_job_description_applicants_url(@job_description)
        else
          flash[:notice] = "you still have non-zero values for percent worth, potential worth and percent worth per vacancy"
          redirect_to :back
        end
      else
        if @job_description.potential_worth.to_f != 0.0 && @job_description.percent_worth.to_f != 0.0 && @job_description.vacancy_percent_worth.to_f != 0.0
          flash[:success] = "you successfully updated your company"
          redirect_to :back
        else  
          flash[:notice] = "you still have non-zero values for percent worth, potential worth and percent worth per vacancy"
          redirect_to :back
        end
      end
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
    if @job_description.company.contacted?
      if @job_description.updated? && @job_description.edit_user_id != current_user.id
        flash[:alert] = "can't proceed with this action. this jd is currently being worked on."
        redirect_to :back 
      else  
  	    @job_description.update(update_button: true, edit_user_id: current_user.id)
  	    redirect_to admin_company_url(@job_description.company, tab: "job descriptions") + "#job descriptions"
      end
    else
      flash[:alert] = "you must first contact the company with this job description"
      redirect_to admin_companies_url(company_id: @job_description.company.id)
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
     :applicant_percent_worth, :earnings, :vacancy_worth, :vacancy_percent_worth, :edit_user_id)
  end
end
