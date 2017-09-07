module Error
  module ErrorHandler
    def self.included base 
      base.class_eval do 
        # unless !Rails.env.production?  
      	  rescue_from StandardError, with: :unknown_error
          rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
        # end
      end
    end

    def routing_error(exception)
      flash[:alert] = "error: you tried navigating a route that does not exist. The system has recorded this issue for later resolution!"
      bug = BugReport.create error_message: exception.message, stacktrace: exception.backtrace, resolution_status: "unresolved"

      if current_user
        if current_user.admin?
          redirect_to admin_dashboard_url
        else  
          redirect_to root_url
        end
      else
        redirect_to root_url
      end    
    end

    private 

    def unknown_error(exception)
      flash[:alert] = "oops! something went wrong. Error: #{exception.message}. The system has recorded this issue for later resolution!"
      bug = BugReport.create error_message: exception.message, stacktrace: exception.backtrace, resolution_status: "unresolved"
      Rails.logger.error 
      if current_user
        if current_user.admin?
      	  redirect_to admin_dashboard_url
        else	
          redirect_to root_url
        end
      else
        redirect_to root_url
      end         	
    end

    def record_not_found(exception)
      flash[:alert] = "the resource you are looking for doesn't exist.The system has recorded this issue for later resolution!"
      bug = BugReport.create error_message: exception.message, stacktrace: exception.backtrace, resolution_status: "unresolved"

      if current_user
        if current_user.admin?
          redirect_to admin_dashboard_url
        else  
          redirect_to root_url
        end
      else
        redirect_to root_url
      end    
    end
  end
end