Rails.application.routes.draw do
  scope module: :web do
    root "bulletins#index"

    post "auth/:provider", to: "auth#request", as: :auth_request
    match "auth/:provider/callback", to: "auth#callback", as: :callback_auth, via: %i[get post]
    delete "auth/logout"

    resources :users, only: %i[new]
    resource :profile, only: %i[show]

    resources :bulletins, only: %i[index new create show edit update] do
      member do
        patch :to_moderate
        patch :archive
      end
    end

    namespace :admin do
      root "home#index"
    end
  end
end
