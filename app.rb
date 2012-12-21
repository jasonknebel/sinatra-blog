require 'sinatra'
require 'slim'
require 'json'

require 'sinatra/activerecord'

configure :development do
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


 get '/make' do
   Post.create(title: "Hello there!", content:"This is my content. Hope you like what I have to say: You look wonderful today!")
 end


configure :production do
  db = URI.parse(ENV['DATABASE_URL'])

    ActiveRecord::Base.establish_connection(
      :adapter  => db.scheme == 'postgres' ? 'postgresql' : db.scheme,
      :host     => db.host,
      :username => db.user,
      :password => db.password,
      :database => db.path[1..-1],
      :encoding => 'utf8'
    )
end