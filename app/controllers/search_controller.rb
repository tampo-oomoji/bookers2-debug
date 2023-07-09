class SearchController < ApplicationController
  before_action :authenticate_user!
  def search
    @model = params[:model]
  
    if @model == "User"
      @users = User.search_for(params[:content], params[:method])
    else
      @books = Book.search_for(params[:content], params[:method])
    end 
    
  end 
end
  
  

