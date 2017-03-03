Rails.application.routes.draw do

  devise_for :users
  root to: 'pages#home'

  resources :users, only: [:show, :edit, :update] do
    resources :questions, only: [:show] do
      resources :answers, only: [:create]
    end
  end

  resources :rooms, only: [:new, :create, :show]
  resources :questions, only: [:index, :new, :create, :edit, :update] #pundit
  resources :matches, only: [:index]
  resources :answers, only: [:new, :edit, :update]
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
