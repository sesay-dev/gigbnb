FactoryGirl.define do
  factory :location do
    title "Lovely duplex"
    description Faker::Lorem.paragraph
    address
    beds 2
    guests 3
    price 34.00
  end
end
