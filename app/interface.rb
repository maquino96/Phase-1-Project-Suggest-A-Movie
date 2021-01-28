require 'pry'

class Interface

    attr_reader :prompt
    attr_accessor :questionnaire, :user, :genre_str, :genre

    def initialize
        @prompt = TTY::Prompt.new
    end 

    def run
        welcome
        q1
    end 

    def welcome
        puts "Welcome to Lord of the Movies"
        prompt.select("Please select from the following") do |main|
            main.choice "Sign in", -> { user_sign_in }
            main.choice "Sign up", -> { user_sign_up }
            main.choice "Exit", -> { exit }
        end
    end 

    def user_sign_in
    
        name = prompt.ask("Please enter your Username")
        if User.find_by(name: name)
            password = prompt.ask("Please enter your Password")
            user = User.all.find_by(name: name, password: password)
            if User.find_by(password: password)
                self.questionnaire = Questionnaire.create(name: user.name, user_id: user.id) 
            else
                puts "Wrong password"
                welcome
            end
        else
            puts "Username does not exist. Please make account"
            welcome
        end
    end

    def user_sign_up
        name = prompt.ask("Please enter your new Username")
        while User.find_by(name: name)
            puts "Account already ctreated with this name"
            name = prompt.ask("Please enter your new Username")
        end 
        password = prompt.mask("Please enter your new Password")
        user = User.create(name: name, password: password)
        self.welcome
    end

    def exit
        puts "Goodbye, Thanks for using Lord of the Movies"
    end

    #####Questionnaire##### 

    def q1
 
        prompt.select("Choose a Category:") do |menu|
            menu.choice "Action", -> {q2action}
            menu.choice "Drama", -> {q2drama}
            menu.choice "Fantasy", -> {q2fantasy}
        end 

        self.questionnaire.update(q2answer: self.genre_str)
        genre = Genre.create(name: self.genre_str, questionnaire_id: questionnaire.id) 

        return_movie(genre)
    end 

    def q2action

        prompt.select("Choose an action based genre:") do |menu|
            menu.choice "Thriller", -> {self.genre_str = "Thriller"}
            menu.choice "Crime", -> {self.genre_str = "Crime"}
            menu.choice "Adventure", -> {self.genre_str = "Adventure"}
        end 

    end 

    def q2fantasy

        prompt.select("Choose a a fantasy based genre:") do |menu|
            menu.choice "Sci-Fi", -> {self.genre_str = "Sci-Fi"}
            menu.choice "Animation", -> {self.genre_str = "Animation"}
            menu.choice "Superhero", -> {self.genre_str = "Superhero"}
        end 

    end 

    def q2drama
    
        prompt.select("Choose a drama based genre:") do |menu|
            menu.choice "Romance", -> {self.genre_str = "Romance"}
            menu.choice "Mystery", -> {self.genre_str = "Mystery"}
            menu.choice "Drama", -> {self.genre_str = "Drama"}
        end 

    end 

    def q2surprise
        # pick and display a random movie 
    end 

    def oneMovieToRuleThemAll
        # only recommends one of the LoTR movies
    end 

    ###### SEEDED MOVIE -- MVP #####
    # def return_movie
    #     # using self.genre, return a movie and it's details
    #     gen_arr = Movie.all.select{|movie| movie.genre == self.genre_str}
    #     movie_inst = gen_arr[rand(0..gen_arr.length-1)]
    #     binding.pry 
    #     puts "The movie chosen for you is #{movie_inst.name} and it has a rating of #{movie_inst.rating} stars with a feature length of #{movie_inst.length} minutes."
    # end 

    def return_movie(genre_inst)
        
        sampled_movie = genre_inst.get_movie_id_api
        new_movie = Movie.create(genre: genre_inst.name, imdb_id: sampled_movie)
        new_movie.movie_metadata_api

    end 

end 
