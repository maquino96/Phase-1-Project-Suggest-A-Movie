require 'pry'

class Interface

    attr_reader :prompt
    attr_accessor :questionnaire, :user, :genre

    def initialize
        @prompt = TTY::Prompt.new
        @user = nil
        @questionnaire = nil
    end 

    # def welcome
    #     puts "Welcome to Lord of the Movies"
    #     prompt.select("Please select from the following") do |main|
    #         main.choice "Sign in", -> { user_sign_in }
    #         main.choice "Sign up", -> { user_sign_up }
    #         main.choice "Exit", -> { exit }
    #     end
    # end 

    # def user_sign_in
    #     name = prompt.ask("Please enter your Username")
    #     if User.find_by(name: name)
    #         password = prompt.ask("Please enter your Password")
    #         user = User.all.find_by(name: name, password: password)
    #     # binding.pry
    #         if User.find_by(password: password)
    #             self.questionnaire = Questionnaire.create(name: "TestQ", user_id: user.id) 
    #         else
    #             puts "Wrong password"
    #             self.welcome
    #         end
    #     else
    #         puts "Username does not exist. Please make account"
    #         self.welcome
    #     end
    #     self.q1 
    # end

    def login_or_signup
        username = down_ask("Enter your username to sign up/log in:")
        @user = User.find_or_create_by(username: username, password: password)
        self.questionnaire = Questionnaire.create(name: "TestQ", user_id: user.id) 
    end

    # def user_sign_up
    #     name = prompt.ask("Please enter your new Username")
    #     while User.find_by(name: name)
    #         puts "Account already ctreated with this name"
    #         name = prompt.ask("Please enter your new Username")
    #     end 
    #     password = prompt.mask("Please enter your new Password")
    #     user = User.create(name: name, password: password)
    #     self.welcome
    # end

    def exit
        puts "Goodbye, Thanks for using Lord of the Movies"
    end

    ##assumption: a Q# has been created with user

    #####Questionnaire##### 

    def q1
        # self.questionnaire = Questionnaire.create(name: "TestQ") 
        # display question (using tty selector)
        # depending on what is selected run the appropriate q2 method
        prompt.select("Choose a Category:") do |menu|
            menu.choice "Action", -> {q2action}
            menu.choice "Drama", -> {q2drama}
            menu.choice "Fantasy", -> {q2fantasy}
        end 

        self.questionnaire.update(q2answer: genre)
        genre_var = Genre.create(name: self.genre, questionnaire_id: questionnaire.id) 

        return_movie
    end 

    #  q2subquestion

    def q2action
        # display action generes (using tty selector)
        # depending on what is selected create new Genre#
        prompt.select("Choose an action based genre:") do |menu|
            menu.choice "Thriller", -> {self.genre = "Thriller"}
            menu.choice "Crime", -> {self.genre = "Crime"}
            menu.choice "Adventure", -> {self.genre = "Adventure"}
        end 

    end 

    def q2fantasy
        # display action generes (using tty selector)
        # depending on what is selected create new Genre#

        prompt.select("Choose a a fantasy based genre:") do |menu|
            menu.choice "Sci-Fi", -> {self.genre = "Sci-Fi"}
            menu.choice "Animation", -> {self.genre = "Animation"}
            menu.choice "Superhero", -> {self.genre = "Superhero"}
        end 

    end 

    def q2drama
        # display action generes (using tty selector)
        # depending on what is selected create new Genre#
        prompt.select("Choose a drama based genre:") do |menu|
            menu.choice "Romance", -> {self.genre = "Romance"}
            menu.choice "Mystery", -> {self.genre = "Mystery"}
            menu.choice "Drama", -> {self.genre = "Drama"}
        end 

    end 

    def q2surprise
        # pick and display a random movie 
    end 

    def oneMovieToRuleThemAll
        # only recommends one of the LoTR movies
    end 

    def return_movie
        # using self.genre, return a movie and it's details
        gen_arr = Movie.all.select{|movie| movie.genre == self.genre}
        movie_inst = gen_arr[rand(0..gen_arr.length-1)]
        # binding.pry 
        puts "The movie chosen for you is #{movie_inst.name} and it has a rating of #{movie_inst.rating} stars with a feature length of #{movie_inst.length} minutes."
    end 

end 

puts "TEST1.2.3"