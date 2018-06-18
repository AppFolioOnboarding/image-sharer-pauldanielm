Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'images#index'
  resources :images, only: %i[new create show index destroy]
  resources :feedbacks, only: [:new]

  namespace :api do
    resource :feedbacks, only: [:create]
  end
end
