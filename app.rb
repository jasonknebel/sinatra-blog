require 'sinatra'
require 'sinatra/activerecord'
require 'slim'
require 'will_paginate'
require 'will_paginate/active_record'
require 'redcarpet' #markdown
require 'uri'

#--------------------Setup--------------------#

require_relative 'helpers/init.rb'
require_relative 'models/init.rb'
require_relative 'routes/posts_route.rb'

use Rack::MethodOverride

#--------------------App_Routes--------------------#

get '/' do 
  @posts = Post.where('published_at IS NOT NULL').order('published_at DESC').page(params[:page]).per_page(5)
  slim :index 
end

get '/show/:url' do
  @post = Post.find_by_url(params[:url])
  slim :show
end

get '/admin' do
  protected!
  @posts = Post.order('published_at DESC, created_at DESC').page(params[:page]).per_page(10)
  slim :admin
end