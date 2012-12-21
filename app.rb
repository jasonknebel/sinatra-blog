require 'sinatra'

require 'rack-livereload'
require 'sinatra/reloader' if development?
use Rack::LiveReload

get '/' do
  "hello, world"
end