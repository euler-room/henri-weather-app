Rails.application.routes.draw do
  resources :locations
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  post 'locations/:id/toggle_temp_units', to: 'locations#toggle_temp_units'
  post 'locations/:id/refresh', to: 'locations#refresh'
end
