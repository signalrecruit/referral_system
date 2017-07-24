class Admin::CompaniesController < Admin::ApplicationController
  before_action :set_admin_authorization_parameters, only: [:update_button, :update, :destroy, :contact_company, :deal_with_company]
  before_action :set_company, only: [:show, :edit, :update, :destroy, :update_button, :contact_company,
   :deal_with_company]
  layout "admin"


  def index
  	@companies = Company.all.order(created_at: :asc)
    @company_id = params[:company_id].to_i
    @notifier_id = params[:notifier_id].to_i
  end

  def show
    @tab = params[:tab]
    @applicant_id = params[:applicant_id]
  end

  def edit
  end
  
  def update
  	if @company.update(company_params)
  	  @company.update(update_button: false, edit_user_id: nil)	
  	  flash[:success] = "you successfully updated #{@company.company_name} details"
  	  redirect_to :back
  	else
  	  flash.now[:alert] = "oops! sthg went wrong"
  	  render :edit
  	end
  end

  def destroy
    if @company.job_descriptions.any? || @company.applicants.any?
  	   flash[:alert] = "this action is not possible. This company has jds and applicants associated with it. please contact the admin for help with this issue"
       redirect_to :back
    else   
      @company.destroy
  	  flash[:success] = "succesfully deleted company"
  	  redirect_to :back
    end
  end

  def update_button
    if @company.updated? && @company.edit_user_id != current_user.id
      flash[:alert] = "can't proceed with this action. this company is currently being worked on."
      redirect_to [:admin, @company, tab: "company"]
    else   
  	  @company.update(update_button: true, edit_user_id: current_user.id)
  	  redirect_to :back
    end
  end

  def contact_company
    if @company.contacted?
      if @company.deal?
        flash[:alert] = "not applicable. A deal has already been made with #{@company.company_name}"
        redirect_to :back
      else
        @company.no_contact
        redirect_to admin_companies_url(company_id: nil)
      end 
    else
      @company.contact
      CompanyContactNotificationService.new({ company: @company, actor: current_user, action: "contacted", recipient: @company.user, resource: @company,
        resource_type: "company" }).notify_user
      flash[:success] = "contacted #{@company.company_name}" 
      redirect_to admin_companies_url(company_id: nil)
    end
  end

  def deal_with_company
    if @company.deal?
      if @company.job_descriptions.any? { |jd| jd.applicants.any? }
        flash[:alert] = "not applicable. Applicants have been linked with this company."
      else
        @company.no_deal
        track_activity @company, "no deal", @company.user_id 
        update_jds_of_company_in_activity @company
        update_company_in_activity @company
      end
    else
      if @company.contacted?
        @company.deal_true 
        CompanyDealNotificationService.new({ company: @company, actor: current_user, action: "deal", recipient: @company.user, resource: @company,
        resource_type: "company"  }).notify_user
        track_activity @company, "deal", @company.user_id 
        permit_jds_of_company_in_activity @company
        flash[:success] = "you and #{@company.company_name} have a deal"
      else
        flash[:alert] = "not applicable. you haven't contacted #{@company.company_name} yet"
      end
    end
    redirect_to :back
  end
 


  private

  def set_company
  	@company = Company.find(params[:id])
  end

  def company_params
    params.require(:company).permit(:company_name, :clientname, :email, :phonenumber, :role,
  	:url, :about, :contacted, :deal, :edit_user_id)
  end

  def permit_jds_of_company_in_activity(company)
    company.job_descriptions.each do |jd|
      track_activity jd, "create", jd.user_id if jd.completed?
    end
  end

  def update_jds_of_company_in_activity(company)
    company.job_descriptions.each do |jd|
      if activity_exists? jd, "JobDescription", "create"
        activity = Activity.find_by trackable_id: jd.id, trackable_type: "JobDescription", action: "create"
         activity.update(action: "inactive") 
      end
    end  
  end

  def update_company_in_activity(company)
    if activity_exists? company, "Company", "deal"
      activity = Activity.find_by trackable_id: company.id, trackable_type: "Company", action: "deal"
      activity.update(action: "inactive")
    end
  end

  def set_admin_authorization_parameters
    Authorization::AdminAuthorizationPolicy.new(current_user, set_company, "company", self).implement_authorization_policy
  end
end
