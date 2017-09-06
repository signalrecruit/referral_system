class Admin::BugReportsController < Admin::ApplicationController
  layout "admin"

  def index
  	@bug_reports = BugReport.all.order(created: :asc)
  end

  def show 
  	@bug_report = BugReport.find(params[:id])
  end
end
