FactoryGirl.define do
  factory :job_description do
    job_title "MyString"
    experience 1
    min_salary "9.99"
    max_salary "9.99"
    vacancies 1
    update_button false
    company nil
  end
end
