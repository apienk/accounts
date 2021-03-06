FactoryGirl.define do
  factory :doorkeeper_application, :class => Doorkeeper::Application do
    sequence(:name){ |n| "Application #{n}" }
    redirect_uri "https://app.com/callback"
    association :owner, factory: :group
    email_from_address 'app@app.com'
    email_subject_prefix '[Application]'
    skip_terms false
    uid { SecureRandom.hex(8) }

    trait :trusted do
      trusted true
    end
  end
end
