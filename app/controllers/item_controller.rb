require 'pry'
class ItemController < ApplicationController 
  
  get "/items/clear_all" do
  
    Item.all.each do |item| 
      item.delete 
    end
    
    User.all.each do |other_user|
      other_user.delete 
    end
    session.clear 
    redirect "/"
  end
  
  get '/items/new_bucket_list_item' do 
    if logged_in?(session)
      @message = session[:message]
      session[:message] = ""
      @user = current_user(session)
      @unique_items = Item.all.map{|item|item[:name]}.uniq  #populates an array of unique names of Items created by all users
      @items_not_created_by_user = @unique_items.collect do |item_name|
        if !@user.items.collect{|user_item|user_item[:name]}.include?(item_name) #iterates through and collects only item names created by all other users
          item_name
        end
      end.compact! #removes nil values
      @items = @items_not_created_by_user.collect{|item_name|Item.find_by(name: item_name)} #repuopulates the array to have the entire item instance, and not just name
      
      
      erb :"items/create_item", locals: {message:"#{@message}"}
    else
      session[:message] = "Cannot create a bucket list unless logged in, please create a new user or log in to continue."
      redirect '/' 
    end
  end
  
  post '/items/new_bucket_list_item' do 
  
    if !logged_in?(session)
      session[:message] = "Cannot create a bucket list unless logged in, please create a new user or log in to continue."
      redirect '/' 
    end
  
    @user = current_user(session)
    @new_items = []
    
    if params["name"] != "" && !@user.items.collect{|item|item[:name]}.include?(params["name"]) 
      @item = Item.create(name: params["name"], description: params["description"], location: params["location"], rank_list: params["rank_list"], user_id: session[:id])
    
      if @item.rank_list.nil?
        @item.rank_list = 0 
        @item.save
      end

      if params["completed"] 
        @item.completed = true
        @item.save
      end
      @user.items << @item
      @new_items << @item
    end
    
    if params.any?{|key,value| key == "item_ids"}
      params["item_ids"].each do |item_id|
        @found_item = Item.find(item_id.to_i)
        if !@user.items.collect{|item|item[:name]}.include?(@found_item.name) 
          @new_item = Item.create(name: @found_item.name, description: @found_item.description, location: @found_item.location, rank_list: 0, user_id: session[:id], completed: false)
          @user.items << @new_item
          @new_items << @new_item
        end
      end
      
    end
 
    if @new_items != []
      if @item.nil?
        @item = @new_items.last
      end
      if @new_items.length > 1
        session[:message] = "To View All Newly Created Bucket List Items, Please Visit Your Homepage."
        redirect "/items/#{@item.id}"
      else
        redirect "/items/#{@item.id}"
      end
    else
      session[:message] = "Must select or create a bucket list item."
      redirect "/items/new_bucket_list_item"
    end
  end
  
  get '/items/index' do
    if !logged_in?(session)
      session[:message] = "Cannot view all bucket items unless logged in, please create a new user or log in to continue." 
      redirect "/"
    end
    
    @items = Item.all
    @user = current_user(session)
    erb :"items/index"
  end
  
  delete "/items/:id/delete" do
    if !logged_in?(session)
      session[:message] = "Cannot delete bucket items unless logged in, please create a new user or log in to continue."
      redirect "/"
    end
    
    @item = Item.find(params[:id])
    @user = current_user(session)
    
    if !@item.user_id == current_user(session).id
      session[:message] = "Bucket List Item Created By Another User"
      redirect "/homepage" 
    else
      @item.delete
      session[:message] = "Item Sucussfully Deleted."
      redirect "/homepage"
    end
  end
  
  get '/items/:id' do  
    if !logged_in?(session)
      session[:message] = "Cannot view a bucket list item unless logged in, please create a new user or log in to continue."
      redirect "/"
    end
    
    @item = Item.find(params[:id])
    
    if @item.user_id != session[:id]
      session[:message] = "Cannot view a bucket list item you did not create."
      redirect "/homepage"
    end
    
    @message = session[:message]
    session[:message] = ""
    erb :"items/show_item", locals: {message:"#{@message}"}
  end
  
  get "/items/:id/edit" do
    if !logged_in?(session)
      session[:message] = "Cannot edit a bucket list item unless logged in, please create a new user or log in to continue."
      redirect '/'
    end
   
    @item = Item.find(params[:id])
  
    if @item.user_id == session[:id]
      erb :"items/edit_item"
    else
      session[:message] = "Can only edit bucket list items you have created."
      redirect "/homepage" 
    end
      
  end
  
  patch "/items/:id" do
    if !logged_in?(session)
       session[:message] = "Cannot edit a bucket list item unless logged in, please create a new user or log in to continue."
       redirect "/"
    end
    
    @item = Item.find(params[:id])
    
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