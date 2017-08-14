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
end
