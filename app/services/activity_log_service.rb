class ActivityLogService 
  def initialize(params)
  	@actor = params[:actor]
  	@resource = params[:resource]
  	@resource_type = params[:resource_type]
  	@action = params[:action]
  end

  def log_user_activity
  	create_activity_log
  end
  
  private 

  def create_activity_log
  	if @resource.nil?
      ActivityLog.create actor_fullname: @actor.fullname, actor_id: @actor.id, action: @action, resource_type: @resource_type
    else
      ActivityLog.create actor_fullname: @actor.fullname, actor_id: @actor.id, action: @action, resource_id: @resource.id, resource_type: @resource.class.name
  	end
  end
end