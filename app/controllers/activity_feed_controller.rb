class ActivityFeedController < ApplicationController
  before_action :authenticate_user!	
  after_action :log_user_activity, only: [:index]
  
  def index
  	@feed = Activity.order(updated_at: :desc)
  	# fresh_when last_modified: @feed.maximum(:updated_at)
  end

  def show
  end


  private 

  def log_user_activity
    ActivityLogService.new({ actor: current_user, action: "viewed", resource_type: "Activities" }).log_user_activity
  end
end
