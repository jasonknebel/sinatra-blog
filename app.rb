require 'sinatra'
require 'slim'
require 'json'

require 'sinatra/activerecord'

if development?
  set :database, 'postgres://jason@localhost/blog_dev'
  require 'rack-livereload'
  require 'sinatra/reloader'
  use Rack::LiveReload
end

class Post < ActiveRecord::Base
end

get '/' do slim :index end

get '/posts' do
  Post.all.to_json
end

get '/admin' do
  @posts = Post.all
  slim :admin
end

get '/new' do redirect '/admin/new' end
get '/admin/new' do slim :new end
post '/admin/new' do "hello there" end

get '/log_in' do slim :log_in end


# get '/make' do
#   Post.create(title: "Hello there!", content:"This is my content. Hope you like what I have to say: You look wonderful today!")
# end


configure :production do
  db = ENV["DATABASE_URL"]
  if db.match(/postgres:\/\/(.*):(.*)@(.*)\/(.*)/) 
    username = $1
    password = $2
    hostname = $3
    database = $4

    ActiveRecord::Base.establish_connection(
      :adapter  => 'postgresql',
      :host     => hostname,
      :username => username,
      :password => password,
      :database => database
    )
  end
end