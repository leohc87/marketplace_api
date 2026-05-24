# frozen_string_literal: true

require 'rack/cors'

Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins 'api.lvh.me'

    resource '*',
             headers: :any,
             methods: %i[get post put patch delete options head]
  end
end
