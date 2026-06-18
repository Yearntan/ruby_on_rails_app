# Routes configuration file for the Rails application. Defines all the URL mappings to controller actions.
Rails.application.routes.draw do

  # Static routes for single pages
  get '/about', to: 'static_pages#about'
  get '/privacy', to: 'static_pages#privacy'
  get '/cookies', to: 'static_pages#cookies'
  get '/contact', to: 'static_pages#contact'
  get '/newuser', to: 'static_pages#newuser'
  # Basic pages like About, Privacy, etc., managed through a StaticPages controller.

  # Invitation system related routes, allowing creation of new invites
  resources :invites, only: [:new, :create]

  # Contact form routes, simplified by directly routing to new and create actions
  resources :contacts, only: [:new, :create]
  get '/contacts', to: 'contacts#new'
  post '/your_endpoint', to: 'contacts#create'

  # Routes for question categories, fully resourced
  resources :ques_categories

  # Question routes including custom member actions to activate or deactivate questions
  resources :questions do
    member do
      patch :deactivate
      patch :activate
    end
  end

  # Devise routes for user authentication
  devise_for :users, controllers: {
    registrations: 'registrations'
  }
  resources :supporter_managements

  # Routes for future messages including a custom action to publish a message
  resources :future_messages do
    member do
      patch :publish
    end
  end

  # Routes for managing alerts on future messages, with deactivate as a member action
  resources :future_message_alerts do
    member do
      patch :deactivate
    end
  end

  # Nested routes under questions for answers, enabling index, show, etc., on answers related to a specific question
  resources :questions do
    resources :answers
  end

  # Routes for managing young people with nested routes for their answers and future messages
  resources :young_people do
    resources :answers, only: [:index] 
    resources :future_messages, only: [:index]
  end

  # Answer routes including a custom action to remove media from an answer
  resources :answers do
    delete :remove_media, on: :member
  end

  # Routes for question change requests nested under questions
  resources :questions do
    resources :change_requests, only: [:new, :create, :destroy, :index]
  end
  resources :change_requests, only: [:index, :show]

  # Routes for managing emotional supports with a complete action
  resources :emotional_supports do 
    member do
      patch :complete
    end
  end

  # General routes for other resources such as young people, answer alerts, and bubbles
  resources :young_people
  resources :answer_alerts do
    member do
      patch :deactivate
    end
  end

  resources :bubbles do
    member do
      get 'manage_members'
      patch 'update_members'
      get 'invite_loved_one'
      post 'create_invite'
    end
  end

  resources :bubble_invites, only: [:index] do
    member do
      patch 'accept'
      patch 'reject'
    end
  end

  # Specific routes for young person managements including a member action for marking a young person as passed away
  resources :young_person_managements, param: :user_id do
    member do
      patch :passed_away
    end
  end

  resources :questions_controllers
  get 'login', to: 'sessions#new', as: 'login'
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy', as: 'logout'

  # Routes for user with custom actions for activating or deactivating a supporter role
  resources :users do
    member do
      patch 'make_supporter_unactive'
      patch 'make_supporter_active'
    end
  end

  # API routes for various entities, structured within the api/v1 namespace
  namespace :api do
    namespace :v1 do
      get 'login', to: 'sessions#new', as: 'login'
      post 'login', to: 'sessions#create'
      delete 'logout', to: 'sessions#destroy', as: 'logout'
      get 'about', to: 'static_pages#about'
      get 'privacy', to: 'static_pages#privacy'
      get 'cookies', to: 'static_pages#cookies'
      get 'newuser', to: 'static_pages#newuser'
      resources :supporter_managements
      resources :young_person_managements, param: :user_id do
        member do
          patch :passed_away
        end
      end
      resources :users do
        member do
          patch 'make_supporter_unactive'
          patch 'make_supporter_active'
        end
      end
      resources :support, only: [:create]
      resources :questions, only: [:index, :show, :create, :update, :destroy]
      resources :change_requests, only: [:index, :show, :create, :destroy]
      resources :ques_categories, only: [:index, :show, :create, :destroy]
      resources :answers, only: [:index, :show, :create, :update, :destroy]
      resources :answer_alerts
      resources :contacts 
      resources :invites
      resources :emotional_supports do
        member do
          put :complete
        end
      end
        # Routes for future messages including a custom action to publish a message
      resources :future_messages do
        member do
          patch :publish
        end
      end
      resources :future_message_alerts
      resources :bubbles, only: [:index, :show, :create, :update, :destroy] do
        resources :members, only: [:index, :show, :create, :update, :destroy]
        post 'assign', to: 'bubbles#assign'
        post 'unassign', to: 'bubbles#unassign'
      end
      resources :members, only: [:index, :show, :create, :update, :destroy]
    end
  end

  # Admin namespace for managing invites
  namespace :admin do
    resources :invites, only: [:index, :destroy]
  end

  # Default root path route and additional devise user session routes
  devise_scope :user do
    root to: "devise/sessions#new"
    # Defines the application's root path which points to the login screen.
  end
end
  # This comments each routing line to provide clarity on what each route is responsible for and how they're structured within the application.
