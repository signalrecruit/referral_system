class JobDescriptionCreateNotificationService
  def initialize(params)
  	@actor = params[:actor]
  	@action = params[:action]
  	@resource = params[:resource]
  	@resource_type = params[:resource_type]
  end

  def notify_admins_and_users
    create_notification
  end


  private 

  def create_notification
  	if deal_with_company_of_jd?
      (User.all - [@actor]).each do |recipient|	
      	if notification_already_created? recipient
  	      Notification.create recipient_id: recipient.id, actor_id: @actor.id, action: "updated", resource_id: @resource.id, resource_type: @resource_type,
  	      actor_username: @actor.username
  	    else
  	      Notification.create recipient_id: recipient.id, actor_id: @actor.id, action: @action, resource_id: @resource.id, resource_type: @resource_type,
  	      actor_username: @actor.username	
  	    end	
  	  end
  	else 
      User.all.where(admin: true).each do |recipient|
      	if notification_already_created? recipient
  	      Notification.create recipient_id: recipient.id, actor_id: @actor.id, action: "updated", resource_id: @resource.id, resource_type: @resource_type,
  	      actor_username: @actor.username
  	    else
  	      Notification.create recipient_id: recipient.id, actor_id: @actor.id, action: @action, resource_id: @resource.id, resource_type: @resource_type,
  	      actor_username: @actor.username	
  	    end	
  	  end
  	end
 end  

  def notification_already_created?(recipient)
  	@recipient = recipient
  	@recipient_notification = nil
    JobDescription.all.each do |jd|
      @recipient_notification = Notification.find_by resource_id: jd.id, recipient_id: @recipient.id, resource_type: "job description", action: "posted"
    end
    @recipient_notification.nil? ? false : true 
  end

  def deal_with_company_of_jd? 
    @resource.company.deal? 
  end
end