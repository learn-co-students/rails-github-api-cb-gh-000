class SessionsController < ApplicationController
  skip_before_action  :authenticate_user, only: :create

  def create
    resp = Faraday.post('https://github.com/login/oauth/access_token') do |req|
      req.params['client_id'] = ENV['CLIENT_ID']
      req.params['client_secret'] =  ENV['CLIENT_SECRET']
      req.params['code'] = params['code']
      # req.params['redirect_uri'] = "http://127.0.0.1:3000/auth"
      req.params['state'] = (0...10).map { ('a'..'z').to_a[rand(26)] }.join
      req.headers['Accept'] = 'application/json'
    end

    body = JSON.parse(resp.body)
    session[:token] = body['access_token']

    user_resp = Faraday.get('https://api.github.com/user') do |req|
      req.headers['Authorization'] = "token #{session[:token]}"
    end

    user_json= JSON.parse(user_resp.body)
    session[:username] = user_json['login']
    # byebug
    redirect_to '/'

  end
end