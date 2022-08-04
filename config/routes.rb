Rails.application.routes.draw do
  post '/auth/login', to: 'authentication#login'
  scope :transactions do
    post '/authorize', to: 'transactions#authorize'
    post '/charge', to: 'transactions#charge'
    post '/refund', to: 'transactions#refund'
    post '/reverse', to: 'transactions#reverse'
  end

  namespace :admin do
    scope :transactions do
      get '/authorize', to: 'transactions#authorize'
      get '/charge', to: 'transactions#charge'
      get '/refund', to: 'transactions#refund'
      get '/reversal', to: 'transactions#reversal'
      post '/del_old', to: 'transactions#delete_old_transactions'
      get '/:uuid', to: 'transactions#show'
    end

    scope :users do
      get '/', to: 'users#index'
      get '/:id', to: 'users#show'
      put '/update/:id', to: 'users#update'
      delete '/:id', to: 'users#destroy'
    end
  end
  get '/status', to: 'application#status'
end
