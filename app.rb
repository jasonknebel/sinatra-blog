require 'sinatra'
require 'slim'
require 'sass'

if development?
  require 'rack-livereload'
  require 'sinatra/reloader'
  use Rack::LiveReload
end

class App < Sinatra::Base

  get '/style.css' do
    sass style.to_sym
  end

  get '/' do
    slim :index
  end

  if __FILE__ == $0
    App.run! :port => 4000
  end
end