Rails.application.routes.draw do
  get 'products/index'
  get 'products/show'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  # config/routes.rb

root 'products#index'


resources :products, only: [:index, :show] do
  post 'purchase', on: :member
end

end
