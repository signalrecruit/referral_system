class Admin::ActivityFeedController < Admin::ApplicationController
  layout "admin"

  def index
  	@feed = Activity.order(created_at: :desc)
  	# fresh_when last_modified: @feed.maximum(:updated_at)
  end

  def show
  end
end
