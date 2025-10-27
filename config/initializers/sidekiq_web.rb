require "sidekiq/web"

if Rails.env.production?
  Sidekiq::Web.set :session_secret, Rails.application.secret_key_base

  Sidekiq::Web.use Rack::Auth::Basic, "Restricted Area" do |user, pass|
    u_ok = ActiveSupport::SecurityUtils.secure_compare(
      user.to_s, ENV.fetch("SIDEKIQ_USER", "admin").to_s
    )
    p_ok = ActiveSupport::SecurityUtils.secure_compare(
      pass.to_s, ENV.fetch("SIDEKIQ_PASSWORD", "").to_s
    )
    u_ok & p_ok
  end
end
