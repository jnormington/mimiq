Rails.application.routes.draw do
  root 'home_page#show'
  get 'home_page/show'

  resource :scenario, only: [:index] do
    get '/'               => 'scenario#index'
    get 'timeout'         => 'scenario#timeout'
    get 'not_found'       => 'scenario#not_found'
    get 'server_error'    => 'scenario#server_error'
    get 'get/:request_by' => 'scenario#get', as: :get
  end

  resources :responses, except: [:destroy, :show]
end
