class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :authenticate_user

  private

    def authenticate_user
      # make sure to pass in the scope parameter (`repo` scope should be appropriate for what we want to do) in step of the auth process!
      # https://developer.github.com/apps/building-oauth-apps/authorization-options-for-oauth-apps/#web-application-flow
      client_id = ENV['CLIENT_ID']
      redirect_uri = CGI.escape("http://127.0.0.1:3000/auth")
      scope = CGI.escape('repo,user')
      state = (0...10).map { ('a'..'z').to_a[rand(26)] }.join
      github_uri = "https://github.com/login/oauth/authorize?client_id=#{client_id}&redirect_uri=#{redirect_uri}&scope=#{scope}&state=#{state}"
      redirect_to github_uri unless logged_in?
    end

    def logged_in?
      !!session[:token]
    end
end
