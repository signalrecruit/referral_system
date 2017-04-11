class JobDescriptionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_company, except: [:update_button]
  before_action :set_job_description, only: [:show, :edit, :update, :destroy]


  def index
  end

  def show
  end

  def new
  	@job_description = @company.job_descriptions.build
  end
  
  def create
  	@job_description = @company.job_descriptions.build(job_params)

  	if @job_description.save 
  	  flash[:notice] = "you have successfully created a job description"
  	  redirect_to [@company, @job_description]
  	else
  	  flash.now[:errors] = "oops! something went wrong"
  	  render :new
  	end
  end

  def edit
  end

  def update
  	if @job_description.update(job_params)
  	  @job_description.update(update_button: false)	
  	  flash[:notice] = "you successfully updated job description"
  	  redirect_to :back
  	else
  	  flash[:errors] = "oops! something went wrong"
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
  	redirect_to :back
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
  	params.require(:job_description).permit(:job_title, :experience, :min_salary, :max_salary, :vacancies, :update_button)
  end
end
