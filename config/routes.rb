Rails.application.routes.draw do
  get 'ratings/safe-new', to: 'ratings#safe_new'
  post 'ratings/safe-create', to: 'ratings#safe_create'
  resources :ratings
  root to: 'ratings#index'
end
