class Company < ActiveRecord::Base
  belongs_to :user
  has_many :job_descriptions, dependent: :destroy

  validates :company_name, :clientname, :role, :email, :phonenumber, :about, presence: true

  def updated?
  	return true if self.update_button?
  end
end
