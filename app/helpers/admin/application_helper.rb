module Admin::ApplicationHelper
  def authorize?(resource) 
    if Role.all.empty? 
      yield
    elsif Role.find_by role: "owner", user_id: current_user.id, resource_id: resource.id, resource_type: resource.class.name
      yield
    elsif Role.find_by role: "no owner", resource_id: resource.id, resource_type: resource.class.name
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
