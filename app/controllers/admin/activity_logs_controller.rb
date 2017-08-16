class Admin::ActivityLogsController < Admin::ApplicationController
  layout 'admin'

  def index
  	@activity_logs = ActivityLog.all.order(created_at: :asc)
  	fresh_when last_modified: @activity_logs.maximun(:updated_at)
  end

  def show
  	@activity = ActivityLog.find(params[:id])
  	fresh_when @activity
  end
end
