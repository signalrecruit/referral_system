class Admin::ActivityFeedController < Admin::ApplicationController
  layout "admin"

  def index
  	@feed = Activity.all
  end

  def show
  end
end
