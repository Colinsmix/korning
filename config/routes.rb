Korning::Application.routes.draw do
 resources :employees, only: [:index, :show]
 resources :customers, only: [:index, :show]
 resources :products, only: [:index, :show]
 resources :sales, only: [:index, :show]
end
