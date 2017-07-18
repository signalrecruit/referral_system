class CompanyCreateNotificationService
  def initialize(params)  	
  	@actor = params[:actor]
  	@action = params[:action]
  	@resource = params[:resource]
  	@resource_type = params[:resource_type]
  end

   
  def notify_admin
    create_notification
  end


  private

  def create_notification
  	User.all.where(admin: true).each do |recipient|
      Notification.create recipient_id: recipient.id, actor_id: @actor.id, action: @action, resource_id: @resource.id, resource_type: @resource_type,
      actor_username: @actor.username
    end
  end
end