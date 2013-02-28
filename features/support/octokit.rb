require 'mimic'

OCTOKIT_DOMAIN = 'http://localhost:9999'

Aruba.configure do |config|
  config.before_cmd do |cmd|
    set_env 'OCTOKIT_API_ENDPOINT', OCTOKIT_DOMAIN
    set_env 'OCTOKIT_WEB_ENDPOINT', OCTOKIT_DOMAIN
  end
end

Mimic.mimic :port => 9999 do
  set :rate_limit, 5000
  set :raise_errors, Proc.new { false }
  set :show_exceptions, false

  before do
    headers 'X-RateLimit-Limit'     => settings.rate_limit.to_s,
            'X-RateLimit-Remaining' => (settings.rate_limit - 1).to_s,
            'Content-Type'          => 'application/json'
  end

  after do
    settings.rate_limit = settings.rate_limit - 1
  end

  post '/authorizations' do
    headers 'Location' => "#{OCTOKIT_DOMAIN}/authorizations/1"
    body = {
      'id' => 1,
      'url' => "#{OCTOKIT_DOMAIN}/authorizations/1",
      'scopes' => [
        'public_repo'
      ],
      'token' => 'abc123',
      'app' => {
        'url' => 'http://my-github-app.com',
        'name' => 'my github app'
      },
      'note' => 'optional note',
      'note_url' => 'http://optional/note/url',
      'updated_at' => '2011-09-06T20:39:23Z',
      'created_at' => '2011-09-06T17:26:27Z'
    }.to_json
    [201, headers, body]
  end

  get '/rate_limit' do
    json = {
      'rate' => {
        'remaining' => (settings.rate_limit - 1),
        'limit'     => settings.rate_limit
      }
    }.to_json
    [200, headers, json]
  end

  get '/user/orgs' do
    json =[
      {
        'login' => 'something',
        'id'    => 2,
        "url"   => "#{OCTOKIT_DOMAIN}/orgs/something"
      }
    ].to_json
    [200, headers, json]
  end

end
