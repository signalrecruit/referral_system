class Company < ActiveRecord::Base
  belongs_to :user
  has_many :job_descriptions, dependent: :destroy

  validates :company_name, :clientname, :role, :email, :phonenumber, :about, presence: true

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
end
