Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      match "contact", to: "contacts#index", via: :get
      match "contact", to: "contacts#create", via: :post
      match "contact", to: "contacts#update", via: :put
      match "contact", to: "contacts#destroy", via: :delete
    end
  end
end
