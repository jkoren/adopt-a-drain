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

  scope '/sidebar', controller: :sidebar do
    get :search, as: 'search'
    get :combo_form, as: 'combo_form'
    get :edit_profile, as: 'edit_profile'
  end

  # this is not the problem.. the email still comes when the below is commented out..

  scope '/drain_admin', controller: :free_drain do
    puts "entering routes.rb"
    get :free_drain, as: 'free_drain'
  end

  resource :reminders
  resource :things
  mount RailsAdmin::Engine => '/admin', :as => 'rails_admin'
  root to: 'main#index'
end
