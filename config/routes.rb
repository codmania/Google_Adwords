Rails.application.routes.draw do
  
  resources :reports

  #root to: 'reports#real_time_stats'
  root :to => "home#index"

  get 'real_time_stats', to: 'reports#real_time_stats', as: :real_time_stats
  get 'garage_flooring', to: 'reports#garage_flooring', as: :garage_flooring
  get 'garage_cabinetry', to: 'reports#garage_cabinetry', as: :garage_cabinetry
  get 'in_home', to: 'reports#in_home', as: :in_home
  get 'all_campaigns', to: 'reports#all_campaigns', as: :all_campaigns

  get "accounts/index", as: :account_index
  get "accounts/input", as: :account_input
  get "accounts/select"

  get "campaigns/index", as: :campaigns
  get "home/index"
  
  get "login/prompt"
  get "login/callback"
  get "login/logout", as: :logout

  get "reports/index", as: :reports_index
  post "reports/get"

end
