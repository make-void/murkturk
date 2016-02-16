require 'haml'
require 'sinatra'



set :protection, :except => :frame_options

get "/" do
  haml :index
end
