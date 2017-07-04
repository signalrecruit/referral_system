class Admin::ApplicationController < ApplicationController
  before_action :authorize_user!, :unapproved_users, :new_companies, :uncompleted_roles, :new_applicants

  layout "admin"

  def unapproved_users
    @unapproved_users = User.all.where(admin: false, approval: false)  
  end

  def new_companies 
    @new_companies = Company.all.where(contacted: false)
  end

  def uncompleted_roles 
  	@uncompleted_roles = JobDescription.all.where(vacancies_filled: false)
  end

  def new_applicants
  	@new_applicants = Applicant.all.where(status: "none")
  end


  private

  def authorize_user!
  	authenticate_user!

  	unless current_user.admin?
  	  redirect_to root_path, alert: "YOU ARE NOT AUTHORIZED! You lack certain permissions to proceed further"
  	end
  end
end
