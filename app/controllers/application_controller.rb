class ApplicationController < ActionController::Base

  require 'redcarpet/compat'
  
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :set_nsfw_preferences

  def set_nsfw_preferences
    if params[:show_nsfw].present?
      session[:show_nsfw] = !!params[:show_nsfw]
    end
  end
end
