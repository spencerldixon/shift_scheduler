FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@test.com" }
    password { "test1234" }
    password_confirmation { "test1234" }

    trait :with_shifts do
      after(:create) do |user|
        5.times do |n|
          FactoryBot.create(
            :shift,
            user: user,
            start_time: DateTime.now.monday.change(hour: 9) + n.days,
            end_time: DateTime.now.monday.change(hour: 17) + n.days
          )
        end
      end
    end
  end
end
