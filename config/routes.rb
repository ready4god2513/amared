Rails.application.routes.draw do


  get "r/:subreddit(/:sort(/:time))", to: "home#index", as: "subreddit"
  root "home#index"
  
end