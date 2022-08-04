Rails.application.routes.draw do
  post '/auth/login', to: 'authentication#login'
  scope :transactions do
    post '/authorize', to: 'transactions#authorize'
    post '/charge', to: 'transactions#charge'
    post '/refund', to: 'transactions#refund'
    post '/reverse', to: 'transactions#reverse'
  end
  get '/status', to: 'application#status'
end
