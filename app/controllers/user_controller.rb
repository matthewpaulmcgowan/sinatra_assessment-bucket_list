require 'pry'
class UserController < ApplicationController
  
    get '/signup' do
      if Helpers.logged_in?(session)
        redirect "/homepage" 
      end
      @message = session[:message]
      session[:message] = ""
      erb :"users/signup", locals: {message:"#{@message}"}
    end
    
    post '/signup' do 
      if params["username"] == ""
        session[:message] = "Username must contain characters, please enter new Username."
        redirect "/usignup"
      end
      @user = User.new(username: params["username"], password: params["password"])
      if @user.save 
        session[:id] = @user.id
        erb :"users/user_list"
      else
        session[:message] = "Password must not be left empty, please enter new Password."
        redirect "/signup"
      end
    end
    
    get '/login' do
      binding.pry
      if Helpers.logged_in?(session)
        redirect "/homepage" 
      end
      @message = session[:message]
      session[:message] = ""
      erb :"users/login", locals: {message:"#{@message}"}
    end
    
    post '/login' do
      binding.pry
      @user = User.find_by(username: params["username"])
      binding.pry
      if @user && @user.authenticate(params["password"])
        session[:id] = @user.id
        erb :"users/user_list"
      else
        session[:message] = "Login unsucessful, Please re-enter Username and Password"
        redirect "/login"
      end
    end
    
    get "/logout" do 
      if Helpers.logged_in?(session)
        session.clear
        erb :index, locals: {message:"Sucessfully logged out."}
      else
        erb :index, locals: {message:"Not currently logged in, could not complete logout"}
      end
    end
    
    get "/homepage" do
binding.pry
      if !Helpers.logged_in?(session)
        session[:message] = "Cannot view your bucket list unless logged in, please create a new user or log in to continue."
        redirect "/"
      end
      
      @user = Helpers.current_user(session)
      @message = session[:message]
      session[:message] = ""
      erb :"users/user_list", locals: {message:"#{@message}"}
    end
    
    get "/connections" do 
      if !Helpers.logged_in?(session)
        session[:message] = "Cannot view connections unless logged in, please create a new user or log in to continue."
        redirect "/"
      end
      @user = Helpers.current_user(session)
      @connections = Item.make_item_connections(@user)
      erb :"users/connect_users" 
    end
      
end