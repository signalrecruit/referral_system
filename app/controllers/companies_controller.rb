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
  	  flash[:notice] = "you succesfully created a company with name #{@company.company_name}"
  	  redirect_to user_companies_url(current_user)
  	else
  	  flash.now[:errors] = "oops! something went wrong"
  	  render :new
  	end
  end

  def edit
  end

  def update
  end

  def destroy
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
