class ActivityFeedController < ApplicationController
  before_action :authenticate_user!	
  
  def index
  	@feed = Activity.order(created_at: :desc)
  end

  def show
  end
end
