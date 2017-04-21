FactoryGirl.define do
  factory :applicant do
    name "MyString"
    email "MyString"
    phonenumber "MyString"
    location "MyString"
    min_salary "MyString"
    max_salary "MyString"
    company nil
    job_description nil
    user nil
    attachment "MyString"
    update_button false
  end
end
