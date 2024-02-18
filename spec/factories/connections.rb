FactoryBot.define do
  factory :connection do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    email_address { Faker::Internet.email }
    company { Faker::Company.name }
    position { Faker::Job.title }
    connected_on { Faker::Date.between(from: 1.year.ago, to: Date.today) }
  end
end