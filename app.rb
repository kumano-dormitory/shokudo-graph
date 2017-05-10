require 'sinatra'
require './lib/graph'

get '/' do
  erb :index
end

post '/upload' do
  tmp_file_path = '/tmp/shokudo.xls'
  File.write(tmp_file_path, params[:excel][:tempfile].read)

  @plot = generate_plot(tmp_file_path)
  erb :index
end
