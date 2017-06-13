FactoryGirl.define do
  factory :bank_account do
    account_holder "MyString"
    account_number "MyString"
    bank_name "MyString"
    sort_code "MyString"
    account_holder_address "MyText"
    user nil
  end
end
