require 'sinatra'
require 'sinatra/activerecord'
require 'slim'
require 'will_paginate'
require 'will_paginate/active_record'
require 'redcarpet' #markdown
require 'uri'

#--------------------Setup--------------------#

class Post < ActiveRecord::Base
end

use Rack::MethodOverride

# if you use heroku's (free) database, you should be able to remove
# the prouction config block and leave this line
database_url = ENV['DATABASE_URL'] || 'sqlite3:///db/blog_development.sqlite3'

#set :database, database_url

configure :development do
  set :database, database_url
  require 'rack-livereload'
  require 'sinatra/reloader'
  use Rack::LiveReload
end

# you can almose definitely delete this and pull the set :database line
# out of the dev block
configure :production do
  
  url = 'postgres://wuqpwjisgdpowf:32MaQxPw9KuirG1lLyQheJbfBS@ec2-54-243-224-187.compute-1.amazonaws.com:5432/dem3n9jlpj5976'
  db = URI.parse(url)

  ActiveRecord::Base.establish_connection(
    :adapter  => 'postgresql',
    :host     => db.host,
    :port     => db.port,
    :username => db.user,
    :password => db.password,
    :database => db.path[1..-1],
    :encoding => 'unicode',
    :pool     => '5'
  )
end 

#--------------------Helpers--------------------#

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

  def markdown(text)
    Redcarpet::Markdown.new(Redcarpet::Render::HTML).render(text)
  end

end

#--------------------Routes--------------------#

get '/url' do
  @url = ENV['DATABASE_URL'] 
  "#{@url}"
end


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