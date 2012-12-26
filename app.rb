require 'sinatra'
require 'slim'
require 'json'
require 'active_record'
require 'uri'


require 'sinatra/activerecord'

configure :development do
  set :database, 'postgres://jason@localhost/blog_dev'
  require 'rack-livereload'
  require 'sinatra/reloader'
  use Rack::LiveReload
end

class Post < ActiveRecord::Base
end

helpers do

  def protected!
    unless authorized?
      response['WWW-Authenticate'] = %(Basic realm="Restricted Area")
      throw(:halt, [401, "Not authorized\n"])
    end
  end

  def authorized?
    @auth ||=  Rack::Auth::Basic::Request.new(request.env)
    @auth.provided? && @auth.basic? && @auth.credentials && 
      @auth.credentials == ['admin', 'admin']
  end

end

get '/' do 
  @posts = Post.find(:all, order: 'published_at DESC')
  slim :index 
end

get '/posts' do
  Post.all.to_json
end

get '/admin' do
  protected!
  @posts = Post.find(:all, order: 'published_at DESC, created_at DESC')
  slim :admin
end

post '/admin/new' do
  slim :new 
end

put '/admin/new' do 
  if (params[:title].empty? || params[:content].empty?)
    "You didn't enter something."
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

post '/admin/edit/:id' do
  @post = Post.find(params[:id])
  slim :edit
end

put '/admin/publish/:id' do
  Post.find(params[:id]).update_attributes(published_at: Time.now)
  redirect '/admin'
end

configure :production do
  ActiveRecord::Base.establish_connection(
    :adapter  => 'postgresql',
    :host     => 'ec2-54-243-224-187.compute-1.amazonaws.com',
    :port     => '5432',
    :username => 'wuqpwjisgdpowf',
    :password => '32MaQxPw9KuirG1lLyQheJbfBS',
    :database => 'dem3n9jlpj5976',
    :encoding => 'unicode',
    :pool     => '5'
  )
end 

put '/admin/edit/:id' do
  Post.find(params[:id]).update_attributes(title: params[:edit_title], 
    content: params[:edit_content])
  redirect '/admin'
end