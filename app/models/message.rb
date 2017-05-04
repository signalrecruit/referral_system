class Message < ActiveRecord::Base
  belongs_to :user

  validates :recipient_name, :content, :title, presence: true

  def save_as_draft?
  	return true if !self.sent?
  	return false if self.sent?
  end
end
