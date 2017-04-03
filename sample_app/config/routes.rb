Rails.application.routes.draw do

  root 'static_pages#home'

  get '/help',      to: 'static_pages#help'
  get '/about',     to: 'static_pages#about'
  get '/contact',   to: 'static_pages#contact'

  get '/signup',    to: 'users#new'
  post '/signup',   to: 'users#create'

  resources :users, only: [:index, :edit, :show, :update, :destroy]

  get '/login',     to: 'sessions#new'
  post '/login',    to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'

  #get "/users", to: 'users#index'
  #post "/users", to: 'users#create'
  #get "/users/new" to: users#new
  #get "users/id/edit" to: users#edit
  #get "/users/id" to: users#$show
  #patch "/users/id" to: users#$update
  #put "/users/id" to: users#$update
  #delete "/users/id" to: users#$destroy


  #1Refer to these to know exactly how routing works in the background.
  #the equivalent of resources: :posts
  #######
  #get "/posts" => "posts#index"
  #get "/posts/:id" => "posts#show"
  #get "/posts/new" => "posts#new"
  #post "/posts" => "posts#create"  # usually a submitted form
  #get "/posts/:id/edit" => "posts#edit"
  #put "/posts/:id" => "posts#update" # usually a submitted form
  #delete "/posts/:id" => "posts#destroy"
  ######Advantage     - You have more explicit control over the routes to controllers
  ######              - Useful if you aren't exactly following RESTful convention
  ######Disadvantage  - More typing

  #2 If I want to leave out options for my "RESTful" resource, use this syntax
  ############
  # resources :posts, :only => [:index, :show]
  #  resources :users, :except => [:index]
  #################

  #3To replace "show" logic for a logged in user context, do this:
  ######get 'profile', to: 'users#show'
  #means - http get request using "profile" uri should direct them to "users#show"
  #let users#show figure out the individual that is logged in.
  #############################

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
