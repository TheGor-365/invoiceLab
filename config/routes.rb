require "sidekiq/web"

Rails.application.routes.draw do
  resources :invoices
  resources :clients
  get "up" => "rails/health#show", as: :rails_health_check
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  scope "(:locale)", locale: /en|ru|es/ do
    devise_for :users

    authenticate :user, lambda { |u| u.admin? } do
      mount Sidekiq::Web => "/sidekiq"
    end

    resources :clients
    resources :invoices

    root "home#index"
  end
end
