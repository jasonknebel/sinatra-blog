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

post '/admin/new' do 
  if (params[:title].empty? || params[:content].empty?)
    "You didn't enter something"
  else
    Post.create( title: params[:title], content: params[:content])
    redirect '/admin'
  end
end

use Rack::MethodOverride
delete '/admin/:id' do
  Post.find(params[:id]).destroy
  redirect '/admin'
end

get '/log_in' do slim :log_in end