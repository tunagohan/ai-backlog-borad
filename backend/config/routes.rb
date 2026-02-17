Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  namespace :api do
    namespace :v1 do
      resources :companies, only: %i[create show] do
        resources :properties, only: %i[index create]
      end

      resources :properties, only: [] do
        resources :stores, only: %i[index create]
      end

      resources :stores, only: [] do
        resources :spaces, only: %i[index create]
      end

      resources :spaces, only: [] do
        resources :assets, only: %i[index create]
      end

      resources :inspection_templates, only: %i[index create show]
      resources :inspection_jobs, only: %i[index create show] do
        member do
          post :start
          post :results, action: :save_results
          post :complete
        end
      end
      resources :issues, only: %i[index create update]
    end
  end
end
