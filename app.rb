require 'sinatra'
require './lib/graph'

get '/' do
  erb :index
end

post '/lunch' do
  tmp_file_path = '/tmp/shokudo.xls'
  File.write(tmp_file_path, params[:excel][:tempfile].read)

  @plot = generate_plot(
    tmp_file_path,
    290, 260
  )
  erb :index
end

post '/dinner' do
  tmp_file_path = '/tmp/shokudo.xls'
  File.write(tmp_file_path, params[:excel][:tempfile].read)

  @plot = generate_plot(tmp_file_path, 420, 390)
  erb :index
end
