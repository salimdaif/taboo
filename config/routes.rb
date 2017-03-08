Rails.application.routes.draw do

  get 'ratings/new'

  get 'ratings/create'

  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  # devise_for :users
  devise_for :users, :controllers => { :registrations => 'users/registrations' }
  root to: 'pages#home'

  resources :users, only: [:show, :edit, :update] do
    # delete 'deactivate', on: :member
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
