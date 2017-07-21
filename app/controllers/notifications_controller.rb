class NotificationsController < ApplicationController
  before_action :set_notification, only: [:mark_as_read]

   def mark_as_read
  	@notification.update(read_at: DateTime.now)
  	if @notification.resource_type == "company" || @notification.resource_type == "job description" || @notification.resource_type == "applicant"
      redirect_to activity_feed_url
  	end
  end

  def mark_all_as_read
  	respond_to do |format|
  	  @notifications = Notification.where(recipient_id: current_user.id).all.update_all(read_at: DateTime.now)
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
