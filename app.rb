require 'sinatra'
require 'slim'


require 'sinatra/activerecord'

if development?
  set :database, 'sqlite:///blog_dev.db'
  require 'rack-livereload'
  require 'sinatra/reloader'
  use Rack::LiveReload
end

get '/' do
  slim :index
end
