class Company < ActiveRecord::Base
  belongs_to :user
  belongs_to :industry
  has_many :job_descriptions, dependent: :destroy
  has_many :activities, as: :trackable, dependent: :destroy
  has_many :applicants, dependent: :destroy
  has_many :roles, dependent: :delete_all

  validates :company_name, :clientname, :role, :email, :phonenumber, :about, presence: true
  validates :phonenumber, format: { with: /\A[-+]?[0-9]*\.?[0-9]+\Z/, message: "only allows numbers" }

  def updated?
  	return true if self.update_button?
  end

  def contact
  	self.update(contacted: true) 
  end

  def no_contact
  	self.update(contacted: false)
  end

  def no_deal
  	self.update(deal: false)
  end

  def deal_true
  	self.update(deal: true)
  end

  def remove_related_activities_from_newsfeed
    
  end
end
