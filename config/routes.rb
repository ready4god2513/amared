Rails.application.routes.draw do


  get 'search', to: "search#index", as: :search
  get 'r/:subreddit/item/:id/comments', to: "comments#index", as: :comments
  
  get "r/:subreddit(/:category(/:time))", to: "r#show", as: "subreddit"
  root "home#index"
  
end