class Admin::ActivityFeedController < Admin::ApplicationController
  layout "admin"

  def index
  	@feed = Activity.order(created_at: :desc)
  end

  def show
  end
end
