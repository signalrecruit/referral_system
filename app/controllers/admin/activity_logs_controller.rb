class Admin::ActivityLogsController < Admin::ApplicationController
  layout 'admin'

  def index
  	@activity_logs = ActivityLog.all.order(created_at: :asc)
<<<<<<< HEAD
  	# fresh_when last_modified: @activity_logs.maximun(:updated_at)
=======
  	fresh_when last_modified: @activity_logs.maximun(:updated_at)
>>>>>>> master
  end

  def show
  	@activity = ActivityLog.find(params[:id])
<<<<<<< HEAD
  	# fresh_when @activity
=======
  	fresh_when @activity
>>>>>>> master
  end
end
