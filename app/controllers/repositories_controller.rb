class RepositoriesController < ApplicationController

  def index
    github = GithubService.new(session[:token])
    @repos_list, @page_link = github.get_repos(params[:page])
  end

  def create
    github = GithubService.new(session[:token])
    is_error = github.create_repos(params[:name])
    # byebug
    # render :index if @is_error
    flash[:error] = is_error['message'] if is_error
    redirect_to root_url
  end
end
