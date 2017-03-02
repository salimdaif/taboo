Rails.application.routes.draw do
  get 'matches/index'

  get 'answers/new'

  get 'answers/create'

  get 'answers/edit'

  get 'answers/update'

  get 'questions/index'

  get 'questions/new'

  get 'questions/create'

  get 'questions/edit'

  get 'questions/update'

  get 'users/show'

  get 'users/edit'

  get 'users/update'

  devise_for :users
  root to: 'pages#home'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
