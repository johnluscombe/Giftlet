FactoryGirl.define do
  factory :user do
    first_name 'Test'
    sequence(:last_name) { |i| "User#{i}" }
    sequence(:username) { |i| "testuser#{i}" }
    password 'password'
    password_confirmation 'password'
  end

  factory :gift do
    user
    sequence(:name) { |i| "Gift #{i}" }

    factory :gift_with_price do
      price 1.0
    end

    factory :gift_with_description do
      description 'Test description'
    end

    factory :gift_with_url do
      url 'http://www.google.com/'
    end
  end
end