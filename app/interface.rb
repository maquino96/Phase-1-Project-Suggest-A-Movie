require 'pry'

class Interface

    attr_reader :prompt, :title
    attr_accessor :questionnaire, :user, :genre_str, :genre

    def initialize
        @prompt = TTY::Prompt.new
    end 

    def run
        welcome
        sleep(0.3)
        q1
        system("clear")
        again 
    end 

    def welcome
        puts "Welcome to..."
        sleep(2)
        # system("clear")
        # sleep(1)
        puts " 
        ,d88~~\                /       /                    d8             e                e    e                         ,e,           
        8888    888  888 e88~88e e88~88e  e88~~8e   d88~\ _d88__          d8b              d8b  d8b      e88~-_  Y88b    /  8   e88~~8e  
        `Y88b   888  888 888 888 888 888 d888  88b C888   888           /Y88b            d888bdY88b    d888  'i  Y88b  /  888 d888  88b 
          Y88b, 888  888 888_88  888_88 8888__888  Y88b   888          /  Y88b          / Y88Y Y888b   8888   *i  Y88 /   888 8888__888 
           8888 888  888  /       /      Y888   ,   888D  888         /____Y88b        /   YY   Y888b  Y888   'i   Y8/    888 Y888    , 
        '__88P' '88*888 Cb      Cb        88___/  '_88P    88_/      /      Y88b      /          Y888b  ""88_-~*      Y     888  688___/  
                          Y8""8D  Y8""8D                                                                                                 
        ".colorize(:light_blue)
        sleep(2.2)
        # system("clear")
        prompt.select("Please select from the following") do |main|
            main.choice "Sign in", -> { user_sign_in }
            main.choice "Sign up", -> { user_sign_up }
            main.choice "Exit", -> { exit }
        end
    end 

    # def login_or_signup
    #     username = down_ask("Enter your username to sign up/log in:")
    #     @user = User.find_or_create_by(username: username, password: password)
    #     self.questionnaire = Questionnaire.create(name: "TestQ", user_id: user.id) 
    # end

    def user_sign_in
        sleep(1.5)
        system("clear")
        name = prompt.ask("Please enter your Username")
        if User.find_by(name: name)
            sleep(0.5)
            password = prompt.mask("Please enter your Password")
            system("clear")
            if User.all.find_by(name: name, password: password) 
                user = User.all.find_by(name: name, password: password)
                self.questionnaire = Questionnaire.create(name: user.name, user_id: user.id) 
            else
                puts "Wrong password for this user please try again"
                sleep(3)
                system("clear")
                self.welcome
            end
        else
            puts "Username does not exist. Please make account"
            sleep(1.5)
            self.welcome
        end
    end

    def user_sign_up
        sleep(1.5)
        system("clear")
        name = prompt.ask("Please enter your new Username")
        while User.find_by(name: name)
            puts "Account already created with this name"
            sleep(2)
            system("clear")
            name = prompt.ask("Please enter your new Username")
            
        end 
        password = prompt.mask("Please enter your new Password")
        user = User.create(name: name, password: password)
        system("clear")
        self.welcome
    end


    def exit
        system("clear")
        puts "Goodbye, Thanks for using Lord of the Movies"
        sleep(2.25)
        system("clear")
        exit!
    end

    #####Questionnaire##### 

    def q1
        sleep(0.5)
        prompt.select("Choose a Category:") do |menu|
            menu.choice "Action", -> { questionnaire.update(q1answer: "Action")
                q2action}
            menu.choice "Drama", -> { questionnaire.update(q1answer: "Drama")
                q2drama}
            menu.choice "Fantasy", -> { questionnaire.update(q1answer: "Fantasy")
                q2fantasy}
        end 

        self.questionnaire.update(q2answer: self.genre_str)
        genre = Genre.create(name: self.genre_str, questionnaire_id: questionnaire.id) 
        system("clear")
        return_movie(genre)
    end 

    def q2action
        binding.pry
        system("clear")
        sleep(0.3)
        prompt.select("Choose an action based genre:") do |menu|
            menu.choice "Thriller", -> {self.genre_str = "Thriller"}
            menu.choice "Crime", -> {self.genre_str = "Crime"}
            menu.choice "Adventure", -> {self.genre_str = "Adventure"}
        end 

    end 

    def q2fantasy
        system("clear")
        sleep(0.3)
        prompt.select("Choose a a fantasy based genre:") do |menu|
            menu.choice "Sci-Fi", -> {self.genre_str = "Sci-Fi"}
            menu.choice "Animation", -> {self.genre_str = "Animation"}
            menu.choice "Superhero", -> {self.genre_str = "Superhero"}
        end 

    end 

    def q2drama
        system("clear")
        sleep(0.3)
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
        
        genre_inst.update(movie_id: new_movie.id)
        new_movie.update(user_id: questionnaire.user_id)
        
        new_movie.movie_metadata_api
        # binding.pry
    end 

    def again
        prompt.select("Would you like another movie  suggested?") do |main|
            main.choice "One more try!", -> { q1 }
            main.choice "No thanks.", -> { exit }
        end

    end 

end 
