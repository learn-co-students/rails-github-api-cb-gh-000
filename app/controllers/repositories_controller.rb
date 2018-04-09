class RepositoriesController < ApplicationController
  def index
    resp = Faraday.get('https://api.github.com/user/repos') do |req|
      req.headers['Authorization'] = "token #{session[:token]}"
      req.params['sort'] = 'created'
    end
    @repos_list = JSON.parse(resp.body)
  end

  def create
    resp =  Faraday.post('https://api.github.com/user/repos') do |req|
      req.headers['Authorization'] = "token #{session[:token]}"
      req.body = { name: params[:name]}.to_json
    end
    if resp.success?
      redirect_to root_url
    else
      @error = JSON.parse(resp.body)
      render :index
    end
    # byebug

  end
end
