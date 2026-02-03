Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      # Autenticação
      post 'auth/register', to: 'auth#register'
      post 'auth/login', to: 'auth#login'
      post 'auth/logout', to: 'auth#logout'
      get 'auth/me', to: 'auth#me'

      # Recursos principais
      resources :books do
        member do
          post 'borrow'
          post 'return'
          post 'reserve'
          post 'favorite'
        end
        collection do
          get 'recommendations'
          get 'search'
          get 'popular'
          get 'recent'
        end
      end

      resources :authors, only: [:index, :show]
      resources :categories, only: [:index, :show]
      resources :publishers, only: [:index, :show]

      # Empréstimos e Reservas
      resources :loans, only: [:index, :show] do
        member do
          post 'return'
          post 'renew'
        end
      end

      resources :reservations, only: [:index, :show, :create, :destroy]

      # Perfil do usuário
      resource :profile, only: [:show, :update] do
        member do
          get 'loans'
          get 'fines'
          get 'notifications'
          put 'notifications/mark_as_read'
        end
      end

      # Admin endpoints
      namespace :admin do
        resources :users, only: [:index, :show, :update, :destroy]
        resources :reports, only: [:index, :create]
        resources :system_settings, only: [:index, :update]
      end

      # Health check
      get 'health', to: 'health#index'
    end
  end

  # Sidekiq Web UI (apenas para admin)
  require 'sidekiq/web'
  authenticate :user, -> (user) { user.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

  # RSawg API docs
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
end