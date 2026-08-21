# frozen_string_literal: true

require 'spec_helper'
ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'shoulda/matchers'
abort('The Rails environment is running in production mode!') if Rails.env.production?
require 'rspec/rails'

rails_support_path = Rails.root.join('spec', 'support', '**', '*.rb')
Dir[rails_support_path].each { |f| require f }

if ENV['RAILS_ENV'] == 'test'
  require 'simplecov'
  SimpleCov.start 'rails'
  puts 'required simplecov'
end

begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  abort e.to_s.strip
end
RSpec.configure do |config|
  config.fixture_path = "#{Rails.root}/spec/fixtures"

  config.use_transactional_fixtures = true

  config.infer_spec_type_from_file_location!

  config.filter_rails_from_backtrace!

  config.include Request::JsonHelpers, type: :request

  config.include Request::HeadersHelpers, type: :request

  # As rotas da API exigem o subdominio `api` (constraints: { subdomain: 'api' }).
  # Sem isso nenhuma rota casa e os specs quebram com erro de roteamento.
  config.before(:each, type: :request) do
    host! 'api.example.com'
  end
end
