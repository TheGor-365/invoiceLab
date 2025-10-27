require_relative "boot"

require "rails/all"

Bundler.require(*Rails.groups)

module InvoiceLab
  class Application < Rails::Application
    config.load_defaults 7.2
    config.autoload_lib(ignore: %w[assets tasks])
    config.i18n.available_locales = %i[en ru es]
    config.i18n.default_locale = :en
    config.i18n.fallbacks = true
    config.time_zone = "Europe/Vienna"
    config.active_job.queue_adapter = :sidekiq

    # config.time_zone = 'UTC'
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")
  end
end
