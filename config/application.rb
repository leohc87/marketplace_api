# frozen_string_literal: true

require_relative 'boot'

require 'rails'
require 'active_model/railtie'
require 'active_job/railtie'
require 'active_record/railtie'
require 'active_storage/engine'
require 'action_controller/railtie'
require 'action_mailer/railtie'
require 'action_mailbox/engine'
require 'action_text/engine'
require 'action_view/railtie'
require 'action_cable/engine'

Bundler.require(*Rails.groups)

module MarketplaceApi
  class Application < Rails::Application
    config.load_defaults 8.1
    config.autoload_lib(ignore: %w[assets tasks])
    config.generators do |generator|
      generator.test_framework :rspec, fixture: true
      generator.fixture_replacement :factory_bot, dir: 'spec/factories'
      generator.view_specs false
      generator.helper_specs false
      generator.stylesheets false
      generator.javascripts false
      generator.helper = false
    end
    config.eager_load_paths << Rails.root.join('lib')
    config.api_only = true
  end
end
