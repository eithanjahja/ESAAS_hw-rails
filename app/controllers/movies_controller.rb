class MoviesController < ApplicationController
    
    @active="hilite"    

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.all_ratings

    if params[:order]
      @order = params[:order]
      session[:order] = @order
    elsif session[:order]
      @order = session[:order]
    else
      @order = ""
    end

    if params[:ratings]
      @ratings_to_show= params[:ratings].keys
      session[:ratings] = params[:ratings]
    elsif not params[:home] and session[:ratings]
      redirect_to movies_path(ratings: session[:ratings], order: session[:order] || "", home: true)
    else
      @ratings_to_show = @all_ratings
    end

    @movies = Movie.get_movies(@ratings_to_show, @order)
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

  private
  # Making "internal" methods private is not required, but is a common practice.
  # This helps make clear which methods respond to requests, and which ones do not.
  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end
end
