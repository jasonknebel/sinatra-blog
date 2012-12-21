require 'sinatra'

require 'rack-livereload' if development?
require 'sinatra/reloader' if development?
use Rack::LiveReload if development?

get '/' do
  "hello, world"
end