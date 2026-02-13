Rails.application.routes.draw do
  namespace :api do
    resources :feature_flags, only: [:index, :create, :update, :show] do
      member do
        get :evaluate
      end
      
      resources :overrides, only: [:create, :update, :destroy], controller: "feature_overrides"
    end
  end
end
