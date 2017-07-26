class Admin::NotificationsController < Admin::ApplicationController
  before_action :set_notification, only: [:mark_as_read]
  layout "admin"

  def mark_as_read
  	@notification.update(read_at: DateTime.now)
  	if @notification.resource_type == "Company" && @notification.action == "updated" 
      redirect_to admin_company_url(Company.find(@notification.resource_id), tab: "company")
    elsif @notification.resource_type == "Company"  
  	  (Company.find(@notification.resource_id)).contacted? ? "#{redirect_to admin_companies_url}" : "#{redirect_to admin_companies_url(notifier_id: Company.find(@notification.resource_id))}"	   
  	elsif @notification.resource_type == "JobDescription" && @notification.action == "posted"
      if role_exists_for JobDescription.find(@notification.resource_id)
  	    JobDescription.find(@notification.resource_id).update(update_button: true, edit_user_id: current_user.id)	
        flash[:success] = "you can go ahead and fill in the necessary values"
  	  end
      redirect_to admin_company_url(JobDescription.find(@notification.resource_id).company, tab: "job descriptions") 
    elsif @notification.resource_type == "JobDescription" && (@notification.action == "updated" || @notification.action == "pending update")
      redirect_to admin_company_url(JobDescription.find(@notification.resource_id).company, tab: "job descriptions")      
  	elsif @notification.resource_type == "Applicant" 
  	  redirect_to admin_manage_all_applicants_url(applicant_id: @notification.resource_id)  	
  	end
  end

  def mark_all_as_read
  	respond_to do |format|
  	  @notifications = Notification.where(recipient_id: current_user.id).all.update_all(read_at: DateTime.now)
  	  format.html { redirect_to :back }
  	  format.js { render json: @notifications}
  	end
  end

  def mark_all_as_seen
  	respond_to do |format|
  	  @notifications = Notification.where(recipient_id: current_user.id).all.update_all(seen_at: DateTime.now)
  	  format.html { redirect_to admin_companies_url }
  	  format.js { render json: @notifications }	
  	end
  end



  private 

  def set_notification
  	@notification = Notification.find(params[:id])
  end

  def notification_params
  	params.require(:notification).permit(:action, :recipient_id, :actor_id, :read_at, :resource_type, :resource_id, :actor_username, :seen_at)
  end

  def role_exists_for resource 
    if role = Role.find_by(role: "owner", user_id: current_user.id, resource_id: resource.id, resource_type: "JobDescription")
      role
    end
  end
end
