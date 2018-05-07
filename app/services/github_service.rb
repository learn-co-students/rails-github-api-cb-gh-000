class  GithubService

  def initialize(token = nil)
    @token = token if token
  end

  def authenticate!(client_id, client_secret, code)
    resp = Faraday.post('https://github.com/login/oauth/access_token') do |req|
      req.params['client_id'] = client_id
      req.params['client_secret'] =  client_secret
      req.params['code'] = code
      req.params['state'] = (0...10).map { ('a'..'z').to_a[rand(26)] }.join
      req.headers['Accept'] = 'application/json'
    end
    body = JSON.parse(resp.body)
    @token = body['access_token']
  end

  def get_username
    user_resp = Faraday.get('https://api.github.com/user') do |req|
      req.headers['Authorization'] = "token #{@token}"
    end
    user_json= JSON.parse(user_resp.body)
    user_json['login']
  end

  def get_repos(page)
    resp = Faraday.get('https://api.github.com/user/repos') do |req|
      req.headers['Authorization'] = "token #{@token}"
      req.params['sort'] = 'created'
      req.params['page'] = page || '1'
    end
    repos_list = JSON.parse(resp.body)
    page_link = resp.headers['link']
    [repos_list, page_link]
  end

  def create_repos(name)
    resp =  Faraday.post('https://api.github.com/user/repos') do |req|
      req.headers['Authorization'] = "token #{@token}"
      req.body = { name: name}.to_json
    end
    JSON.parse(resp.body) unless resp.success?
  end
end