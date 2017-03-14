Rails.application.routes.draw do

  get 'pusher/auth'

  post 'pusher/auth', to: 'pusher#auth'

  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  # devise_for :users
  devise_for :users, :controllers => { :registrations => 'users/registrations' }
  root to: 'pages#home'

  get 'intro', to: 'pages#intro'

  resources :users, only: [:show, :edit, :update] do
    # delete 'deactivate', on: :member
    member do
      get :personality
      get :questionnaire
      post :calculate_insight
    end

    resources :questions, only: [:show] do
      resources :answers, only: [:new, :create]
    end
  end

  resources :rooms, only: [:create, :show]
  resources :questions, only: [:index, :new, :create, :edit, :update] #pundit
  resources :matches, only: [:index]
  resources :answers, only: [:edit, :update, :destroy]
  resources :ratings, only: [:new, :create]
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
