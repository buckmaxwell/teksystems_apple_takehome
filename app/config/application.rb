require_relative "boot"

require "rails/all"

Bundler.require(*Rails.groups)

module App
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 8.0

    ENV["GOOGLE_PLACES_API_KEY"] ||= Rails.application.credentials.google_places_api_key

    config.autoload_lib(ignore: %w[assets tasks])

  end
end
