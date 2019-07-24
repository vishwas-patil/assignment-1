Rails.application.routes.draw do
  namespace :v1 do
    namespace :authorizations, path: '' do
      devise_scope :v1_authorizations_user do
        post '/login', to: 'authenticate#create'
        delete '/logout', to: 'authenticate#revoke'
        post '/register', to: 'register#create'
      end
      devise_for :users, skip: %i[registrations sessions unlocks]
    end
    resources :reviews
    resources :books
    resources :authors
    get '/search', to: 'search#search'
  end
  root 'home#missing_path'
end
