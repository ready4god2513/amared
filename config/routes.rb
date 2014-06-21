Rails.application.routes.draw do


  get "r/:subreddit(/:category(/:time))", to: "home#index", as: "subreddit"
  root "home#index"
  
end