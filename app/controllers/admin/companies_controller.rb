class Admin::CompaniesController < Admin::ApplicationController
  before_action :set_company, only: [:show, :edit, :update, :destroy, :update_button]
  layout "admin"


  def index
  	@companies = Company.all
  end

  def show
  end

  def edit
  end
  
  def update
  	if @company.update(company_params)
  	  @company.update(update_button: false)	
  	  flash[:success] = "you successfully updated #{@company.company_name} details"
  	  redirect_to :back
  	else
  	  flash.now[:alert] = "oops! sthg went wrong"
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
  	@company = Company.find(params[:id])
  end

  def company_params
    params.require(:company).permit(:company_name, :clientname, :email, :phonenumber, :role,
  	:url, :about)
  end
end
