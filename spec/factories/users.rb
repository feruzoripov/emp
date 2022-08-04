FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user_#{n}@test.com" }
    sequence(:name) { |n| "user_#{n}" }
    password { 'password' }
  end
end
