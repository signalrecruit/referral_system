module Admin::ApplicationHelper
  def authorize?(resource)
  	role = Role.find_by role: "owner", resource_id: resource.id, resource_type: resource.class.name 
  	no_role = Role.find_by role: "no owner", resource_id: resource.id, resource_type: resource.class.name
  	
  	if role 
  	  if current_user.roles.include?(role) || Role.all.empty?
        yield  
      elsif !current_user.roles.include?(role)
  	  end
  	elsif role.nil? 
  	  yield  
  	elsif no_role 
  	  yield
  	elsif Role.all.empty?
      yield
  	end
  end

  def pending_updates?(resource)
  	pending_update = (resource.class.name.constantize).find_by copy: true, copy_id: resource.id 
  	if pending_update
  	  yield	
  	end
  end

  def has_role_on_this? resource 
    if Role.where(resource_id: resource.id, resource_type: resource.class.name, role: "owner", user_id: current_user.id).any?
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

  def current_user_has_no_role? resource 
    if Role.find_by(resource_id: resource.id, resource_type: resource.class.name, user_id: current_user.id)
      false 
    else 
      true 
    end
  end
end
