Rails.application.routes.draw do


  get "r/:subreddit(/:sort(/:time))", to: "home#index"
  root "home#index"
  
end