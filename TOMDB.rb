require "net/http"
require 'date'
require 'json'
require 'open-uri'
require 'sinatra'

before do
  @page = :default
  @app_name = "TOMDB"
  # Sets the default page title
  @page_title = @app_name
  @api_key = "xxxxxxxxxxxxxxxxxxxx" #register on TMDB API to get the key
end

get '/' do
  @page = :home
  @page_title += ": Home"
  erb @page
end
get '/search' do
  @query = params[:q]
  @page_title += ": Search Results for #{@query}"
  @button = params[:button]
      uri = URI.parse("http://api.themoviedb.org/3/search/multi?api_key=#{@api_key}&query=#{URI.escape(@query)}")
      http = Net::HTTP.new(uri.host, uri.port)
      request = Net::HTTP::Get.new(uri.request_uri)
      response = http.request(request)
      file = JSON.load(response.body)
      @rescount = file["total_results"]
      @results = file["results"]
  if response.code == "422"
     erb :noentry
  elsif @rescount == 0
     erb :nill
  else @rescount >= 1
      erb :serp
  end
end

get '/movie' do
  @page = :movie
  @id = params[:id]
  @query = params[:q] || ""
  uri = URI.parse("http://api.themoviedb.org/3/movie/#{URI.escape(@id)}?api_key=#{@api_key}")
  http = Net::HTTP.new(uri.host, uri.port)
  request = Net::HTTP::Get.new(uri.request_uri)
  response = http.request(request)
  @results = JSON.load(response.body)
  @genres = @results["genres"]
  @languages = @results["spoken_languages"]
  @companies = @results["production_companies"]
  erb :movie
end
get '/serie' do
  @page = :serie
  @id = params[:id]
  @query = params[:q] || ""
  uri = URI.parse("http://api.themoviedb.org/3/tv/#{URI.escape(@id)}?api_key=#{@api_key}")
  http = Net::HTTP.new(uri.host, uri.port)
  request = Net::HTTP::Get.new(uri.request_uri)
  response = http.request(request)
  @results = JSON.load(response.body)
  @genres = @results["genres"]
  @creators = @results["created_by"]
  @networks = @results["networks"]
  erb :serie
end
