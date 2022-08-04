FactoryBot.define do
  factory :transaction do
    merchant { create(:user) }
    sequence(:customer_email) { |n| "user_#{n}@test.com" }
    customer_phone { '123123123' }

    factory :authorize, class: Transaction::Authorize do
      amount { 10.0 }
    end

    factory :charge, class: Transaction::Charge do
      amount { 10.0 }
    end

    factory :refund, class: Transaction::Refund do
      amount { 10.0 }
    end

    factory :reversal, class:Transaction::Reversal do
    end
  end
end
