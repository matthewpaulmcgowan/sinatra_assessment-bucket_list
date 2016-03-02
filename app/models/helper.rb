class Helpers 
  def self.logged_in?(session)
    !!session[:id]
  end

  def self.current_user(session)
    User.find(session[:id])
  end
  
  def self.connection_user(id)
    User.find(id)
  end

end