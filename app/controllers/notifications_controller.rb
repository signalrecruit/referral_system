class NotificationsController < ApplicationController

  def clicked
    @last_notification = Notification.last	
    @last_notification.update(clicked: false)

    Notification.delete_all
    redirect_to activity_feed_url
  end
end
