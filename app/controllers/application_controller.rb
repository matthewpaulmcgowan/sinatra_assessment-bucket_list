class ApplicationController < Sinatra::Base

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
    set :session_secret, "password_security"
  end
  
  get '/' do
    if logged_in?(session)
      redirect '/homepage'
    else
      @message = session[:message]
      session[:message] = ""
      erb :index, locals: {message:"#{@message}"}
    end
  end
  
  def logged_in?(session)
    !!session[:id]
  end

  def current_user(session)
    User.find(session[:id])
  end
=begin
As I have continued, my program has become messier and messier. I have found each time I have to add a new feauture, I have to change many more parts of the program 
than I initially ancicipate. For now, I am using a has many, through: model between my items user classes. I started with items belonging to users and users having many items.
I then changed thinking that it would be easier to connect users if one item could have many users. I worked to institute the model I have now.
I then changed my mind again because it did not make sense to have a user have a bucket list item they did not own themselves and that they could not edit or "complete" themselves.
So now, I have this model, but one item still only belongs to one user. I could change back the models to have many and belongs to, but I don't believe it does any damage
to leave it as it is. Through this process I did find a way to better connect users. When a user now wishes to create a new bucket list item, they have the option to select 
from all unique(by name) bucket list items from other users and create a new bucket list item with that exact name. Then, i run a search based on slug to create my data for the connections page. 
I did previously use this same model, but to be considered a connection, a user would have had to manually enter the same slug of a name, which is not very practical or likely. 

=end
  
  
  
end