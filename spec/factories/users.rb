FactoryBot.define do
  factory :user do
    is_patient { true }
    is_doctor { false }
    is_admin { false }
    first_name { 'Ruben' }
    last_name { 'Cogburn' }

    trait :patient do
      is_patient { true }
      is_doctor { false }
      is_admin { false }
    end

    trait :doctor do
      is_patient { false }
      is_doctor { true }
      is_admin { false }
    end

    trait :admin do
      is_patient { false }
      is_doctor { false }
      is_admin { true }
    end
  end
end
