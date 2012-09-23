class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings=Movie.ratings 

    #if params[:sort] isn't given/save params
    if (session[:sort]=='title' && params[:sort].blank?) || params[:sort] == 'title'
      @highlight1='hilite'
      session[:sort] = 'title'
    elsif (session[:sort] == 'release_date' && params[:sort].blank?)|| params[:sort]=='release_date'
      @highlight2='hilite'
      session[:sort] = 'release_date'
    end

    #save params[:ratings]
    if !params[:ratings].blank?
      session[:ratings] = params[:ratings]
    end

    #use saved settings
    if (!session[:ratings].blank? && params[:ratings].blank?)
      flash.keep
      redirect_to :action => 'index', :ratings => session[:ratings], :sort => session[:sort]
    end

    #first time navigating to app
    if session[:ratings].blank?
      @shown_ratings=@all_ratings
    else
      @shown_ratings=session[:ratings]
    end

    @movies=Movie.order(session[:sort])
    @movies= @movies.where(:rating => session[:ratings].keys) if session[:ratings].present?
  end


  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
