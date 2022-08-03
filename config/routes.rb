Rails.application.routes.draw do
  post '/auth/login', to: 'authentication#login'
  post '/transactions/authorize', to: 'transactions#authorize'
  post '/transactions/charge', to: 'transactions#charge'
  post '/transactions/refund', to: 'transactions#refund'
  post '/transactions/reverse', to: 'transactions#reverse'
  get '/status', to: 'application#status'
end
