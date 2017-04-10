class Company < ActiveRecord::Base
  belongs_to :user

  validates :company_name, :clientname, :role, :email, :phonenumber, :about, presence: true

  def updated?
  	return true if self.update_button?
  end
end
