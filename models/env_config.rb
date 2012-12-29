configure :development do
  set :database, 'sqlite3:///db/blog_development.sqlite3'
  require 'rack-livereload'
  require 'sinatra/reloader'
  use Rack::LiveReload
end

# configure :test do
# end

configure :production do
  db = URI.parse(ENV['HEROKU_POSTGRESQL_JADE_URL'])

  ActiveRecord::Base.establish_connection(
    :adapter  => db.scheme == 'postgres' ? 'postgresql' : db.scheme,
    :host     => db.host,
    :port     => db.port,
    :username => db.user,
    :password => db.password,
    :database => db.path[1..-1],
    :encoding => 'unicode',
    :pool => 5
  )
end