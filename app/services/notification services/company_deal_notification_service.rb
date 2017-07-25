require "job_description_create_notification_service"

class CompanyDealNotificationService
  def initialize(params)
  	@actor = params[:actor]
  	@action = params[:action]
  	@recipient = params[:recipient]
  	@resource = params[:resource]
  	@resource_type = params[:resource_type]
  end

  def notify_user
  	create_notification 
  end


  private 

  def create_notification
  	Notification.create recipient_id: @recipient.id, actor_id: @actor.id, action: @action, resource_id: @resource.id, resource_type: @resource_type,
  	actor_username: @actor.username
    
    if @resource.job_descriptions.any?
      @resource.job_descriptions.each do |job_description|
        JobDescriptionCreateNotificationService.new( {actor: @resource.user, action: "posted", resource: job_description, resource_type: job_description.class.name, self: self} ).notify_admins_and_users
      end
    end
  end
end