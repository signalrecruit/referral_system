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
  	pending_update = Company.find_by copy: true, copy_id: resource.id 
  	if pending_update
  	  yield	
  	end
  end
end
