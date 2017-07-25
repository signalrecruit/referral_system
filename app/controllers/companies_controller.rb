class CompaniesController < ApplicationController
  before_action :authenticate_user!
  before_action :copy_changes_to_existing_object, only: [:update] 
  before_action :set_company, only: [:show, :edit, :update, :destroy, :update_button]

  def index
  	@companies = current_user.companies - current_user.companies.where(copy: true)
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
      CompanyCreateNotificationService.new({ actor: current_user, action: "created", resource: @company, resource_type: @company.class.name }).notify_admins
      on_success "you succesfully created a company with name #{@company.company_name}", new_company_job_description_url(company_id: @company)
  	else
      on_failure "oops! something went wrong", :new
  	end
  end

  def edit
  end

  def update
  	if @company.update(company_params)
  	  @company.update(update_button: false)	
      create_alias_name_for_company @company
      track_activity @company, params[:action], @company.user.id
      on_success "you successfully updated #{@company.company_name} details", company_url(@company, tab: "company") 
  	else
  	  flash[:errors] = "ooops! something went wrong"
  	  render :edit
  	end
  end

  def destroy
    if @company.job_descriptions.any? || @company.applicants.any?
      flash[:alert] = "can't proceed with this action. this company has associated applicants/job descriptions. please contact the admin for help with this."
    else  
  	  @company.destroy
    	flash[:success] = "succesfully deleted company"
  	end
    redirect_to :back
  end

  def update_button
  	@company.update(update_button: true)
    if request.referrer == user_companies_url(@company.user)
      redirect_to [@company, tab: "company"]
    else
  	  redirect_to :back
    end
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

  def copy_changes_to_existing_object
    @company = Company.find(params[:id])
    if @company.job_descriptions.any?
      if find_company = Company.find_by(copy: true, copy_id: @company.id)
        find_company.delete 
        @save_company = Company.create company_params
        @save_company.update(copy: true, copy_id: @company.id, user_id: @company.user_id, alias_name: @company.alias_name, contacted: @company.contacted, deal: @company.deal)
      else
        @save_company = Company.create company_params
        @save_company.update(copy: true, copy_id: @company.id, user_id: @company.user_id, alias_name: @company.alias_name, contacted: @company.contacted, deal: @company.deal)
      end
      @company.update(update_button: false) 
      CompanyUpdateNotificationService.new({ actor: current_user, action: "updated", resource: @company, resource_type: @company.class.name }).notify_admin
      flash[:alert] = "your update has been saved. but will only reflect on admins authorization"
      redirect_to company_url @company, tab: "company"
    end
  end
end
