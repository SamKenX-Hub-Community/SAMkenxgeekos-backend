ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../config/environment', __dir__)
abort('The Rails environment is running in production mode!') if Rails.env.production?
require 'spec_helper'
require 'rspec/rails'
require 'database_cleaner/mongoid'
require 'json_matchers/rspec'
require 'mongoid-rspec'
require 'factory_bot_rails'
require 'ffaker'
require 'webmock/rspec'

Dir[Rails.root.join('spec/support/**/*.rb')].sort.each { |f| require f }

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end

RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods
  config.include Mongoid::Matchers, type: :model
  config.use_transactional_fixtures = false
  config.infer_spec_type_from_file_location!

  config.before(:suite) do
    DatabaseCleaner.cleaning do
      FactoryBot.lint
    end
    User.remove_indexes
    Tag.remove_indexes
    OrgUnit.remove_indexes
  end

  config.around do |example|
    DatabaseCleaner.cleaning do
      example.run
    end
  end
end
