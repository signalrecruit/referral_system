class ActivityFeedController < ApplicationController
   def index
  	@feed = Activity.all.where(company_action: "deal").order(updated_at: :desc)
  end

  def show
  end
end
