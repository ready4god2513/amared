Rails.application.routes.draw do


  get 'search', to: "search#index", as: :search
  get 'sub', to: "search#subs", as: :search_subs
  get 'domain', to: "search#domain", as: :search_domain

  get 'r/:subreddit/item/:id/comments', to: "comments#index", as: :comments
  get 'r/:subreddit/comments', to: "comments#stream", as: :comment_stream
  get "r/:subreddit(/:category(/:time))", to: "r#show", as: :subreddit
  root "home#index"
  
end