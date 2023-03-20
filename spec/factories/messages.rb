FactoryBot.define do
  factory :message do

    outbox_id {}
    inbox_id {}
    read { false }
    body { 'This is a message text' }

    trait :sent_less_than_a_week_ago do
      created_at { 1.days.from_now }
    end

    trait :sent_more_than_a_week_ago do
      created_at { 8.days.ago }
    end
  end
end