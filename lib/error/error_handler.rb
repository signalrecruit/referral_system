module Error
  module ErrorHandler
    def self.included base 
      base.class_eval do 
        rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
        rescue_from ActionController::RoutingError, with: :routing_error
      end
    end

    def routing_error
      flash[:alert] = "error: you tried navigating a route that does not exist."
      if current_user.admin?
      	redirect_to admin_dashboard_url
      else	
        redirect_to root_url
      end  
    end

    private 

    # def rescue_all_errors
    #   flash[:alert] = "oops! something went wrong."
    #   if current_user.admin?
    #   	redirect_to admin_dashboard_url
    #   else	
    #     redirect_to root_url
    #   end    	
    # end

    def record_not_found
      flash[:alert] = "the resource you are looking for doesn't exist."
      if current_user.admin?
      	redirect_to admin_dashboard_url
      else	
        redirect_to root_url
      end  
    end
  end
end