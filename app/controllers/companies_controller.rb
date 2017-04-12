class CompaniesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_company, only: [:show, :edit, :update, :destroy, :update_button]

  def index
  	@companies = current_user.companies
  end

  def show
  end

  def new
  	@company = current_user.companies.build
  end

  def create
  	@company = current_user.companies.build(company_params)

  	if @company.save
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
  	  flash[:success] = "you successfully updated #{@company.company_name} details"
  	  redirect_to :back
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
  	@company = current_user.companies.find(params[:id])
  end

  def company_params
    params.require(:company).permit(:company_name, :clientname, :email, :phonenumber, :role,
  	:url, :about)
  end
end
