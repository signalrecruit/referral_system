class CompaniesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_company, only: [:show, :edit, :update, :destroy, :update_button]

  def index
  	@companies = current_user.companies
    @applicants = current_user.applicants
  end

  def show
    @tab = params[:tab]
  end

  def new
  	@company = current_user.companies.build
  end

  def create
  	@company = current_user.companies.build(company_params)

  	if @company.save
      
      create_alias_name_for_company @company

      track_activity @company, params[:action], @company.user.id
  	  
      flash[:success] = "you succesfully created a company with name #{@company.company_name}"
  	  redirect_to new_company_job_description_url(company_id: @company)
  	else
  	  flash.now[:errors] = "oops! something went wrong"
  	  render :new
  	end
  end

  def edit
  end

  def update
  	if @company.update(company_params)
  	  @company.update(update_button: false)	
      
      find_and_update_activity @company.id

      create_alias_name_for_company @company

  	  flash[:success] = "you successfully updated #{@company.company_name} details"
  	  # redirect_to :back
      redirect_to company_url(@company, tab: "company") 
  	else
  	  flash[:errors] = "ooops! something went wrong"
  	  render :edit
  	end
  end

  def destroy
  	@company.destroy
  	flash[:success] = "succesfully deleted company"
  	redirect_to :back
  end

  def update_button
  	@company.update(update_button: true)
  	redirect_to :back
  end


  private

  def set_company
    if current_user.companies.include? @company
  	  @company = current_user.companies.find(params[:id])
    else
      @company = Company.find(params[:id])
    end
  end

  def company_params
    params.require(:company).permit(:company_name, :clientname, :email, :phonenumber, :role,
  	:url, :about, :alias_name, :industry_id)
  end

  def create_alias_name_for_company(company)
    @random = SecureRandom.hex(2)
    id = params[:company][:industry_id].to_i
    @industry = Industry.find(id)
    @company.update(alias_name: @industry.name + "-#{@random}")
  end

  def find_and_update_activity(trackable_id)
    activity = Activity.find_by trackable_id: trackable_id

    if activity.action == "deal"
      update_activity "update", @company.id 
    elsif activity.action == "create"
        update_activity "update", @company.id
    end
  end
end
