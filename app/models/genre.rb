
class Genre < ActiveRecord::Base
  belongs_to :movie
  belongs_to :questionnaire
  # add associatons!

  #### This class may have to be renamed to "Requests" -- the genre is determined during the questionnaire phase, and movies are pulled from the api. Atleat from an attribute /relationship standpoint. From there we can collect each of the users genre selections through name and a running list of the movies they've instantiated.
  ####

  def get_movie_id_api
    
    url = URI("https://imdb8.p.rapidapi.com/title/get-popular-movies-by-genre?genre=%2Fchart%2Fpopular%2Fgenre%2F#{self.name.downcase}")

    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    request = Net::HTTP::Get.new(url)
    request["x-rapidapi-key"] = 'c73b41d245msh20db0553e3da24dp1b8850jsn3db5de323bde'
    request["x-rapidapi-host"] = 'imdb8.p.rapidapi.com'

    response = http.request(request)
    hash = response.read_body
    pretty_hash = eval(hash)
    
    arr_movie_ids = []
    pretty_hash.each{ |id| arr_movie_ids << id[7..-2]}
    arr_movie_ids.sample()
    # sample_of_3 = arr_movie_ids.sample(3)
    # puts sample_of_3
  end 


end
