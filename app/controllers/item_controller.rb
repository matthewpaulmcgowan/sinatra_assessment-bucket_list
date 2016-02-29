require 'pry'
class ItemController < ApplicationController 
  
  get "/items/clear_all" do
  
    Item.all.each do |item| 
      item.delete 
    end
    User.all.each do |user|
      user.items = []
    end
    User.all.each do |other_user|
      other_user.delete 
    end
    redirect "/"
  end
  
  get '/items/new_bucket_list_item' do 
    if Helpers.logged_in?(session)
      @message = session[:message]
      session[:message] = ""
      erb :"items/create_item", locals: {message:"#{@message}"}
    else
      erb :index, locals: {message:"Cannot create a bucket list unless logged in, please create a new user or log in to continue."}
    end
  end
  
  post '/items/new_bucket_list_item' do 
    if !Helpers.logged_in?(session)
      session[:message] = "Cannot create a bucket list unless logged in, please create a new user or log in to continue."
      redirect '/' 
    end
    
    @items = Item.all
    @user = Helpers.current_user(session)
    if params["name"] == ""
      session[:message] = "Each new bucket list item must include a name, Please try again."
      redirect "/items/new_bucket_list_item"
    end
    
      @item = Item.create(name: params[:name], description: params["description"], location: params["location"], rank_list: params["rank_list"], user_id: session[:id])

    if @item.rank_list.nil?
      @item.rank_list = 0 
      binding.pry
      @item.save
    end

    if params["completed"] 
      @item.completed = true
      @item.save
    end
    
    erb :"items/show_item"
  end
  
  get '/items/index' do
    if !Helpers.logged_in?(session)
      session[:message] = "Cannot view all bucket items unless logged in, please create a new user or log in to continue." 
      redirect "/"
    end
    
    @items = Item.all
    @user = Helpers.current_user(session)
    erb :"items/index"
  end
  
  delete "/items/:slug/delete" do
    if !Helpers.logged_in?(session)
      session[:message] = "Cannot delete bucket items unless logged in, please create a new user or log in to continue."
      redirect "/"
    end
    
    @item = Item.find_by_slug(params[:slug])
    @user = Helpers.current_user(session)
    
    if !@item.user_id == Helpers.current_user(session).id
      session[:message] = "Bucket List Item Created By Another User"
      redirect "/homepage" 
    else
      @item.delete
      session[:message] = "Item Sucussfully Deleted."
      redirect "/homepage"
    end
  end
  
  get '/items/:slug' do 
    if !Helpers.logged_in?(session)
      session[:message] = "Cannot view a bucket list item unless logged in, please create a new user or log in to continue."
      redirect "/"
    end
    
    @item = Item.find_by_slug(params[:slug])
    erb :"items/show_item"
  end
  
  get "/items/:slug/edit" do
    if !Helpers.logged_in?(session)
      session[:message] = "Cannot edit a bucket list item unless logged in, please create a new user or log in to continue."
      redirect '/'
    end
    
    @item = Item.find_by_slug(params[:slug])
    if @item.user_id == session[:id]
      erb :"items/edit_item"
    else
      session[:message] = "Can only delete bucket list items you have created."
      redirect "/homepage" 
    end
      
  end
  
  patch "/items/:slug" do
    if !Helpers.logged_in?(session)
       session[:message] = "Cannot edit a bucket list item unless logged in, please create a new user or log in to continue."
       redirect "/"
    end
    
    @item = Item.find_by_slug(params[:slug])
    
    if params["description"] != "" 
      @item.description = params["description"]
      @item.save
    end
    
    if params["location"] != "" 
      @item.location = params["location"]
      @item.save
    end
    
    if params["rank_list"] != "" 
      @item.rank_list = params["rank_list"]
      @item.save
    end
    
    if params["completed"] 
      @item.completed = true
      @item.save
    end
    
    erb :"/items/show_item", locals: {message:"Sucussfully Updated Bucket List Item"}
  end
  
end