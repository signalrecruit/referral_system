class NotificationsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_notification, only: [:mark_as_read]

   def mark_as_read
  	@notification.update(read_at: DateTime.now)
  	if @notification.resource_type == "Company" && (@notification.action == "contacted" || @notification.action == "deal" || @notification.action == "authorize")  
      redirect_to user_company_url(current_user, Company.find(@notification.resource_id), tab: "company")
    elsif @notification.resource_type == "JobDescription" && (@notification.action == "posted" || @notification.action == "updated")
      redirect_to activity_feed_url  
    elsif @notification.resource_type == "JobDescription" && @notification.action == "authorize"
      redirect_to company_job_description_url(JobDescription.find(@notification.resource_id).company, JobDescription.find(@notification.resource_id))  
    elsif @notification.resource_type == "Applicant" && (@notification.action == "created" || @notification.action == "none" || @notification.action == "interviewing" || @notification.action == "testing" || @notification.action == "shortlisted" || @notification.action == "salary negotiation" || @notification.action == "not hired")
      redirect_to url_for([Applicant.find(@notification.resource_id).job_description, Applicant.find(@notification.resource_id)])
    elsif @notification.resource_type == "Applicant" && @notification.action == "hired"
      redirect_to user_stats_url
    elsif @notification.resource_type == "Qualification" && @notification.action == "authorize"
      redirect_to company_job_description_url((Qualification.find(@notification.resource_id)).job_description.company, (Qualification.find(@notification.resource_id)).job_description)  
    elsif @notification.resource_type == "RequiredExperience" && @notification.action == "authorize"
      redirect_to company_job_description_url((RequiredExperience.find(@notification.resource_id)).job_description.company, (RequiredExperience.find(@notification.resource_id)).job_description)    
    elsif @notification.resource_type == "Requirement" && @notification.action == "authorize"
      redirect_to company_job_description_url((Requirement.find(@notification.resource_id)).job_description.company, (Requirement.find(@notification.resource_id)).job_description) 
    elsif @notification.resource_type == "Applicant" && @notification.action == "authorize"
      redirect_to company_job_description_url((Applicant.find(@notification.resource_id)).job_description.company, (Applicant.find(@notification.resource_id)).job_description)      
    end
  end

  def mark_all_as_read
  	respond_to do |format|
  	  @notifications = Notification.where(recipient_id: current_user.id).all.update_all(read_at: DateTime.now)
      fresh_when last_modified: @notification.maximum(:updated_at)
  	  format.html { redirect_to :back }
  	  format.js { render json: @notifications }
  	end
  end

   def mark_all_as_seen
  	respond_to do |format|
  	  @notifications = Notification.where(recipient_id: current_user.id).all.update_all(seen_at: DateTime.now)
  	  format.html { redirect_to activity_feed_url }
  	  format.js { render json: @notifications }	
  	end
  end


  private 

  def set_notification
  	@notification = Notification.find(params[:id])
  end

  def notification_params
  	params.require(:notification).permit(:action, :recipient_id, :actor_id, :read_at, :resource_type, :resource_id, :actor_username)
  end
end
