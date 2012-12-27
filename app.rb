require 'sinatra'
require 'sinatra/activerecord'
require 'slim'
require 'will_paginate'
require 'will_paginate/active_record'
require 'redcarpet' #markdown

#--------------------Setup--------------------#

class Post < ActiveRecord::Base
end

use Rack::MethodOverride
  #needed for more than just GET/POST requests

configure :development do
  set :database, 'postgres://jason@localhost/blog_dev'
  require 'rack-livereload'
  require 'sinatra/reloader'
  use Rack::LiveReload
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

#--------------------Helpers--------------------#

helpers do

  def protected!
    unless authorized? 

      redirect '/log_in'

      # response['WWW-Authenticate'] = %(Basic realm="Restricted Area")
      # throw(:halt, [401, "Not authorized\n"])
      
    end
  end

  def auth
    @auth ||= Rack::Auth::Basic::Request.new(request.env)
  end
 

  def authorized?
    auth.provided? && auth.basic? && auth.credentials && 
      auth.credentials == ['admin', 'admin']
  end

  def markdown(text)
    Redcarpet::Markdown.new(Redcarpet::Render::HTML).render(text)
  end

end

#--------------------Routes--------------------#

get '/' do 
  @posts = Post.where('published_at IS NOT NULL').order('published_at DESC').page(params[:page]).per_page(5)
  slim :index 
end

#----------Admin----------#

get '/admin' do
  protected!
  @posts = Post.order('published_at DESC, created_at DESC').page(params[:page]).per_page(10)
  slim :admin
end

#-----Log_In-----#

get '/log_in' do 
  slim :login 
end

post '/log_in' do
  # @auth.credentials = ['admin', params[:pass]]
  protected!
end

#-----New_Post-----#

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

#-----Edit_Post-----#

post '/admin/edit/:id' do
  @post = Post.find(params[:id])
  slim :edit
end

put '/admin/edit/:id' do
  Post.find(params[:id]).update_attributes(title: params[:edit_title], 
    content: params[:edit_content])
  redirect '/admin'
end

#-----Delete_Post-----#

delete '/admin/:id' do
  Post.find(params[:id]).destroy
  redirect '/admin'
end

#-----Publish_Post-----#

put '/admin/publish/:id' do
  Post.find(params[:id]).update_attributes(published_at: Time.now)
  redirect '/admin'
end