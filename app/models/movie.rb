class Movie < ActiveRecord::Base
    has_many :genres
    has_many :questionnaires, through: :genres
    has_many :users, through: :questionnaires
    # add associatons!

    def movie_metadata_api
      
      url = URI("https://imdb8.p.rapidapi.com/title/get-meta-data?ids=#{self.imdb_id}&region=US")

      http = Net::HTTP.new(url.host, url.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE

      request = Net::HTTP::Get.new(url)
      request["x-rapidapi-key"] = 'c73b41d245msh20db0553e3da24dp1b8850jsn3db5de323bde'
      request["x-rapidapi-host"] = 'imdb8.p.rapidapi.com'

      response = http.request(request)
      body = response.body 
      parsed = JSON.parse(body) 
      # hash = response.read_body


      # pretty_hash = hash.to_hash #eval is not being found 

      
      name = parsed[imdb_id]["title"]["title"]
      length = parsed[imdb_id]["title"]["runningTimeInMinutes"]
      rating = parsed[imdb_id]["metacritic"]["userScore"].to_f 

      # binding.pry

      self.update(name: name, length: length, rating: rating) 

      puts "The film selected for you is #{self.name}.".colorize(:green)
      sleep(2.35)
      puts "It has a feature length of #{self.length} minutes and a metacritic score of #{self.rating}.".colorize(:green)
      sleep(2.5)
      puts "."
      sleep(0.3)
      puts".."
      sleep(0.3)
      puts"..."
      sleep(0.3)
      puts".."
      sleep(0.3)
      puts"."
      sleep(0.3)
    end 





end