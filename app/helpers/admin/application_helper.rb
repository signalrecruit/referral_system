module Admin::ApplicationHelper
  def authorize?(company) 
    if Role.all.empty? 
      yield
    elsif Role.find_by role: "owner", user_id: current_user.id, resource_id: company.id, resource_type: "company"
      yield
    elsif Role.find_by role: "no owner", resource_id: company.id, resource_type: "company"
      yield
    end
  end	
end
