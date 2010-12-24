# encoding: utf-8

require 'rubygems'
require 'haml'
require 'sinatra/base'

class FileUpload < Sinatra::Base
  configure do
    enable :static
    enable :sessions

    set :views,  File.join(File.dirname(__FILE__), 'views')
    set :public, File.join(File.dirname(__FILE__), 'public')
    set :files,  File.join(settings.public, 'files')
  end

  helpers do
    def flash(message = '')
      session[:flash] = message
    end
  end

  not_found do
    haml '404'
  end

  error do
    haml "Error (#{request.env['sinatra.error']})"
  end

  get '/' do
    @files = Dir.entries(settings.files) - ['.', '..']

    @flash = session[:flash]
    session[:flash] = nil

    haml :index
  end
  
  post '/upload' do
    if params[:file]
      filename = params[:file][:filename]
      file = params[:file][:tempfile]

      File.open(File.join(settings.files, filename), 'wb') {|f| f.write file.read }

      flash 'Uploaded successfully'
    else
      flash 'You have to choose a file'
    end

    redirect '/'
  end
end

