Rails.application.routes.draw do
  root :to => "locations#index"
  resources :locations
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  post 'locations/:id/toggle_temp_units', to: 'locations#toggle_temp_units', :defaults => { :format => 'js' }
  post 'locations/:id/refresh', to: 'locations#refresh', :defaults => { :format => 'js' }
end
