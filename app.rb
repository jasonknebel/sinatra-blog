require 'sinatra'
require 'slim'
require 'sass'



if development?
  require 'rack-livereload'
  require 'sinatra/reloader'
  use Rack::LiveReload
end



get '/' do
  slim :index
end




# get '/:style.css' do |style|
#   content_type 'text/css'
#   sass style.to_sym
# end