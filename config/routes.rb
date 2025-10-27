require "sidekiq/web"

Rails.application.routes.draw do
  resources :invoices
  resources :clients
  get "up" => "rails/health#show", as: :rails_health_check
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  post "stripe/webhook" => "stripe/webhooks#receive"

  scope "(:locale)", locale: /en|ru|es/ do
    devise_for :users

    get "analytics", to: "analytics#dashboard", as: :analytics_dashboard
    get  "billing" => "billing#pricing"
    post "billing/subscribe" => "billing#subscribe"
    post "billing/portal"    => "billing#portal"
    get  "billing/success"   => "billing#success"
    get  "billing/cancel"    => "billing#cancel"

    authenticate :user, lambda { |u| u.admin? } do
      mount Sidekiq::Web => "/sidekiq"
    end

    resources :clients
    resources :invoices do
      member do
        post :send_created
        post :send_due
        post :send_overdue
        post :send_paid
        get  :pay
      end
    end

    root "home#index"
  end
end
