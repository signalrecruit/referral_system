class BankAccount < ActiveRecord::Base
  belongs_to :user
  validates :account_holder, :account_number, :bank_name, :sort_code, :account_holder_address, presence: true
  validates :account_number, format: { with: /\A[-+]?[0-9]*\.?[0-9]+\Z/, message: "only allows numbers" }

  def updated?
    self.update_button?
  end
end
