class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date, :ratings)
    
  end
  
  

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.all_ratings
    @check_ratings = params[:ratings] || {}
    
    if params[:sort] == 'title'
      session[:sort] = 'title'
      
    elsif params[:sort] == 'release_date'
      session[:sort] = 'release_date'
    
    end
    
    if @check_ratings == {}
      
      if session[:ratings] != {}
        flash.keep
        redirect_to movies_path(:ratings => session[:ratings], :sort => session[:sort])
      else
        @check_ratings = @all_ratings
      end
      
    elsif @check_ratings.class != Array
      
      @check_ratings = @check_ratings.keys
    end
    
    session[:ratings] = @check_ratings

    @movies = Movie.where(:rating => @check_ratings).order(params[:sort]).all
    
    
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
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
