require 'sinatra'
require 'slim'

require 'rack-livereload' if development?
require 'sinatra/reloader' if development?
use Rack::LiveReload if development?

get '/' do
  slim :index
end