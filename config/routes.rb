# frozen_string_literal: true

Rails.application.routes.draw do
  # Redirect to landing page if accessing an unsupported domain.
  match '(*path)',
        to: redirect('https://mysticriver.org', status: 302),
        via: :all,
        constraints: ->(request) { CityHelper.city_for_domain(request.host).nil? }

  devise_for :users, controllers: {
    passwords: 'passwords',
    registrations: 'users',
    sessions: 'sessions',
  }

  get '/address', to: 'addresses#show', as: 'address'
  get '/info_window', to: 'info_window#index', as: 'info_window'
  get '/sitemap', to: 'sitemaps#index', as: 'sitemap'
  get '/drain_admin', to: 'drain_admin#index', as: 'drain_admin'

  put 'things/:id/free', to: 'things#free', as: 'free'
  # put 'users/:id/promote', to: 'users#promote', as: 'promote_user'
  # put 'users/:id/demote', to: 'users#demote', as: 'demote_user'

  scope '/sidebar', controller: :sidebar do
    get :search, as: 'search'
    get :combo_form, as: 'combo_form'
    get :edit_profile, as: 'edit_profile'
  end

  resource :reminders
  resource :things
  mount RailsAdmin::Engine => '/admin', :as => 'rails_admin'
  # mount RailsAdmin::Engine => '/admin/user', :as => 'rails_user_admin'
  root to: 'main#index'
end
