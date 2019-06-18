FactoryBot.define do
  factory :shift do
    association :user
    start_time  { DateTime.new(2019, 6, 18, 9, 0, 0) }
    end_time    { DateTime.new(2019, 6, 18, 14, 0, 0) }
  end
end
