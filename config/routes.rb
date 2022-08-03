Rails.application.routes.draw do
  post '/auth/login', to: 'authentication#login'
  post '/transactions/authorize', to: 'transactions#authorize'
  get '/status', to: 'application#status'
end
