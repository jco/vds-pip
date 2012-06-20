#
# Authors: Jeff Cox, David Zhang
# Copyright Syracuse University
#
# Reference: http://guides.rubyonrails.org/routing.html

VdsPip::Application.routes.draw do
  
  resources :users, :except => :show
  
  resources :projects, :only => [:index, :show, :new, :create] do
    resources :documents, :only => [:new, :create]
    resources :folders, :only => [:new, :create]
  end

  resources :tasks, :only => [:show, :new, :create] do
    resources :documents, :only => [:new, :create]
    resources :folders, :only => [:new, :create]
  end

  resources :folders, :only => [:show, :update] do
    resources :documents, :only => [:new, :create]
    resources :folders, :only => [:new, :create]
    resources :dependencies, :only => :index
  end

  resources :documents, :only => [:show, :update, :destroy] do
    resources :versions, :only => [:new, :create]
  end

  resources :dependencies, :only => [:create]

  resources :versions, :only => :show

  # resource :locations
  resources :locations, :only => :update # only for ajax call in item_drawer.js

  match 'api/:action' => 'api#:action'

  root :to => "projects#index"
end
