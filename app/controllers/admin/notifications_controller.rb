class Admin::NotificationsController < Admin::ApplicationController
  before_action :set_notification, only: [:mark_as_read]
  layout "admin"

  def mark_as_read
  	@notification.update(read_at: DateTime.now)
  	if @notification.resource_type == "company"  
  	  (Company.find(@notification.resource_id)).contacted? ? "#{redirect_to admin_companies_url}"	: "#{redirect_to admin_companies_url(notifier_id: Company.find(@notification.resource_id))}"	   
  	end
  end

  def mark_all_as_read
  	Notification.all.update_all(read_at: DateTime.now)
  	redirect_to admin_companies_url
  end


  private 

  def set_notification
  	@notification = Notification.find(params[:id])
  end

  def notification_params
  	params.require(:notification).permit(:action, :recipient_id, :actor_id, :read_at, :resource_type, :resource_id, :actor_username)
  end
end
