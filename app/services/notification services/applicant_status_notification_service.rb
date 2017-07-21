class ApplicantStatusNotificationService 
  def initialize(params)
  	@actor = params[:actor]
  	@action = params[:action]
  	@resource = params[:resource]
  	@resource_type = params[:resource_type]
  	@recipient = params[:recipient]
  end

  def notify_user 
  	create_notification
  end


  private 

  def create_notification
  	if @action == "hired"
  	  [@recipient, @resource.job_description.user].each do |recipient|	
  	    Notification.create recipient_id: recipient.id, actor_id: @actor.id, action: @action, resource_id: @resource.id, resource_type: @resource_type,
  	    actor_username: @actor.username
  	  end
  	else
  	  Notification.create recipient_id: @recipient.id, actor_id: @actor.id, action: @action, resource_id: @resource.id, resource_type: @resource_type,
  	  actor_username: @actor.username
  	end
  end
end