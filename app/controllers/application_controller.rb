class ApplicationController < Sinatra::Base

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
    set :session_secret, "password_security"
  end
  
  get '/' do
    if Helpers.logged_in?(session)
      redirect '/homepage'
    else
      @message = session[:message]
      session[:message] = ""
      erb :index, locals: {message:"#{@message}"}
      
    end
  end
  
end