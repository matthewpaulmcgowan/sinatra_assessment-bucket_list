require 'pry'
class UserController < ApplicationController
  
    get '/signup' do
      if logged_in?(session)
        redirect "/homepage" 
      end
      @message = session[:message]
      session[:message] = ""
      erb :"users/signup", locals: {message:"#{@message}"}
    end
    
    post '/signup' do 
      if params["username"] == ""
        session[:message] = "Username must contain characters, please enter new Username."
        redirect "/signup"
      end
      @user = User.new(username: params["username"], password: params["password"])
      if @user.save 
        session[:id] = @user.id
        @sorted_user_items = @user.sort_items_by_rank_list
        erb :"users/user_list"
      else
        session[:message] = "Password must not be left empty, please enter new Password."
        redirect "/signup"
      end
    end
    
    get '/login' do
      if logged_in?(session)
        redirect "/homepage" 
      end
      @message = session[:message]
      session[:message] = ""
      erb :"users/login", locals: {message:"#{@message}"}
    end
    
    post '/login' do
      @user = User.find_by(username: params["username"])
      if @user && @user.authenticate(params["password"])
        session[:id] = @user.id
        @sorted_user_items = @user.sort_items_by_rank_list
        erb :"users/user_list"
      else
        session[:message] = "Login unsucessful, Please re-enter Username and Password"
        redirect "/login"
      end
    end
    
    get "/logout" do 
      if logged_in?(session)
        session.clear
        erb :index, locals: {message:"Sucessfully logged out."}
      else
        erb :index, locals: {message:"Not currently logged in, could not complete logout"}
      end
    end
    
    get "/homepage" do
      if !logged_in?(session)
        session[:message] = "Cannot view your bucket list unless logged in, please create a new user or log in to continue."
        redirect "/"
      end
   
      @user = current_user(session)
      @sorted_user_items = @user.sort_items_by_rank_list
      @message = session[:message]
      session[:message] = ""
      erb :"users/user_list", locals: {message:"#{@message}"}
    end
    
    get "/connections" do 
      if !logged_in?(session)
        session[:message] = "Cannot view connections unless logged in, please create a new user or log in to continue."
        redirect "/"
      end
      @user = current_user(session)
      @connections = Item.make_item_connections(@user)
      erb :"users/connect_users" 
    end
      
end