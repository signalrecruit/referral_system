module ApplicationHelper
  def if_resource_exists? notification
    if find_resource notification
      yield 	
    end 
  end

  def find_resource notification
    (notification.resource_type.constantize).find(notification.resource_id)
rescue ActiveRecord::RecordNotFound 
	false
  end

  def has_role_on_this? resource 
    if Role.where(resource_id: resource.id, resource_type: resource.class.name, role: "owner").any?
      yield
    end	
  end

  def has_no_role_on_this? resource 
  	if Role.where(resource_id: resource.id, resource_type: resource.class.name, role: "no owner").any? 
      yield
    end	
  end

  def no_one_has_no_role? resource 
    if Role.find_by(resource_id: resource.id, resource_type: resource.class.name).nil? 
      yield
    end 	
  end
end
