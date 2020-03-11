class Admin::ActivityLogsController < Admin::ApplicationController
  layout 'admin'

  def index
  	@activity_logs = ActivityLog.all.order(created_at: :asc)
  end

  def show
  	@activity = ActivityLog.find(params[:id])
  end
end
