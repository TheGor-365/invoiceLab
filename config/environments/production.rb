require "active_support/core_ext/integer/time"

Rails.application.configure do
  config.enable_reloading = false
  config.eager_load = true
  config.consider_all_requests_local = false
  config.action_controller.perform_caching = true
  config.assets.compile = false
  config.active_storage.service = :local
  config.force_ssl = true
  config.cache_classes = true
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.deliver_later_queue_name = :mailers
  config.action_mailer.perform_caching = false
  config.action_mailer.default_options = { from: ENV.fetch("MAILER_FROM", "no-reply@example.com") }

  config.action_mailer.smtp_settings = {
    address:              ENV.fetch("SMTP_ADDRESS", "smtp.example.com"),
    port:                 Integer(ENV.fetch("SMTP_PORT", "587")),
    domain:               ENV["SMTP_DOMAIN"],
    user_name:            ENV["SMTP_USERNAME"],
    password:             ENV["SMTP_PASSWORD"],
    authentication:       :plain,
    enable_starttls_auto: true
  }

  if ENV["APP_HOST"].present?
    config.hosts << ENV["APP_HOST"]
    config.action_controller.default_url_options = { host: ENV["APP_HOST"], protocol: "https" }
    config.action_mailer.default_url_options     = { host: ENV["APP_HOST"], protocol: "https" }
    config.action_mailer.asset_host              = "https://#{ENV['APP_HOST']}"
  end

  config.logger = ActiveSupport::Logger.new(STDOUT)
    .tap  { |logger| logger.formatter = ::Logger::Formatter.new }
    .then { |logger| ActiveSupport::TaggedLogging.new(logger) }

  config.log_tags = [ :request_id ]
  config.log_level = :info
  config.i18n.fallbacks = true
  config.i18n.available_locales = %i[en ru es]
  config.i18n.default_locale = :en
  config.active_support.report_deprecations = false
  config.active_record.dump_schema_after_migration = false
  config.active_record.attributes_for_inspect = [ :id ]
  config.active_job.queue_adapter = :sidekiq
  config.public_file_server.enabled = true

  # config.require_master_key = true
  # config.assets.css_compressor = :sass
  # config.asset_host = "http://assets.example.com"
  # config.action_dispatch.x_sendfile_header = "X-Sendfile" # for Apache
  # config.action_dispatch.x_sendfile_header = "X-Accel-Redirect" # for NGINX
  # config.action_cable.mount_path = nil
  # config.action_cable.url = "wss://example.com/cable"
  # config.action_cable.allowed_request_origins = [ "http://example.com", /http:\/\/example.*/ ]
  # config.assume_ssl = true
  # config.ssl_options = { redirect: { exclude: ->(request) { request.path == "/up" } } }
  # config.cache_store = :mem_cache_store
  # config.active_job.queue_adapter = :resque
  # config.active_job.queue_name_prefix = "invoice_lab_production"
  # config.action_mailer.raise_delivery_errors = false
  # config.host_authorization = { exclude: ->(request) { request.path == "/up" } }

  # config.hosts = [
  #   "example.com",     # Allow requests from example.com
  #   /.*\.example\.com/ # Allow requests from subdomains like `www.example.com`
  # ]
end
