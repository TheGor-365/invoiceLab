# frozen_string_literal: true

require "sidekiq"

redis_url = ENV.fetch("REDIS_URL", "redis://127.0.0.1:6379/0")

Sidekiq.configure_server do |config|
  config.redis = { url: redis_url }

  # (безопасно: только на стороне воркера подхватит расписание)
  begin
    require "sidekiq/cron/job"
    schedule_file = Rails.root.join("config/schedule.yml")
    if File.exist?(schedule_file)
      Sidekiq::Cron::Job.load_from_hash YAML.load_file(schedule_file)
    end
  rescue LoadError
    # sidekiq-cron не установлен — тихо пропускаем
  end
end

Sidekiq.configure_client do |config|
  config.redis = { url: redis_url }
end
