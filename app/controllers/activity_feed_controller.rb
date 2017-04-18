class ActivityFeedController < ApplicationController
   def index
  	@feed = Activity.all.where(company_action: "deal")
  end

  def show
  end
end
