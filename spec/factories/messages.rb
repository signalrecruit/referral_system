FactoryGirl.define do
  factory :message do
    content "MyString"
    recipient_id "MyString"
    read false
    user nil
  end
end
