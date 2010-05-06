# encoding: utf-8

require 'rubygems'
require 'haml'
require 'pathname'
require 'sinatra/base'

class FileUpload < Sinatra::Base
  configure do
    enable :static
    enable :sessions
    
    set :views, Pathname.new(__FILE__).dirname.join('views').expand_path
    set :public, Pathname.new(__FILE__).dirname.join('public').expand_path
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
    @files = settings.public.join('files').entries - [Pathname.new('.'), Pathname.new('..')]
    
    @flash = session[:flash]
    session[:flash] = nil
    
    haml :index
  end
  
  post '/upload' do
    if params[:file]
      filename = params[:file][:filename]
      file = params[:file][:tempfile]
      
      File.open(settings.public.join('files', filename), 'wb') {|f| f.write file.read }
      
      flash 'Uploaded successfully'
    else
      flash 'You have to choose a file'
    end
    
    redirect '/'
  end
end
