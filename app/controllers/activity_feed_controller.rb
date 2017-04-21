class ActivityFeedController < ApplicationController
  
  def index
  	@feed = Activity.order(updated_at: :desc)
  end

  def show
  end
end
