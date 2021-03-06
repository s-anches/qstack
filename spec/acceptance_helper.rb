require "rails_helper"
require 'capybara/poltergeist'
require 'capybara/email/rspec'

RSpec.configure do |config|
  config.include AcceptanceHelpers, type: :feature
  config.include OmniauthMacros, type: :feature
  config.include SphinxHelpers, type: :feature
  config.use_transactional_fixtures = false

  config.before(:suite) do
    ThinkingSphinx::Test.init
    ThinkingSphinx::Test.start_with_autostop
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner.strategy = :transaction
  end

  config.before(:each, js: true) do
    DatabaseCleaner.strategy = :truncation
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
    FileUtils.rm_rf(Dir["#{Rails.root}/public/uploads"])
  end

  Capybara.javascript_driver = :poltergeist
end

OmniAuth.config.test_mode = true
