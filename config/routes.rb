Rails.application.routes.draw do
  post '/auth/login', to: 'authentication#login'
  get '/status', to: 'application#status'
end
