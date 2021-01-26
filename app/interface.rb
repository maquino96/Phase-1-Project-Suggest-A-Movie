require 'pry'
<<<<<<< HEAD
=======

>>>>>>> 39a0bbe0e534dad0267de81d567d950699fa2a9d

class Interface

    attr_reader :prompt
    attr_accessor :questionnaire, :user

    def initialize
        @prompt = TTY::Prompt.new
        @user = nil
    end 

    def welcome
        puts "Welcome to Lord of the Movies"
        prompt.select("Please select from the following") do |main|
            main.choice "Sign in", -> { user_sign_in }
            main.choice "Sign up", -> { user_sign_up }
            main.choice "Exit", -> { exit }
        end
    end 


    ##INTROSCREEN - Login / Signup

    ##assumption: a Q# has been created with user

    #####Questionnaire##### 

    

    def q1
        questionnaire = Questionnaire.create(name: "TestQ") 
        # display question (using tty selector)
        # depending on what is selected run the appropriate q2 method
        prompt.select("Choose a Category:") do |menu|
            menu.choice "Action", -> {q2action}
            menu.choice "Drama", -> {q2drama}
            menu.choice "Fantasy", -> {q2fantasy}
        end 

        questionnaire.update.user_id = user.id
        questionnaire.update.q2answer = self.genre
        genre_var = Genre.create(name: self.genre, questionnaire_id: questionnaire.id) 

        binding.pry
    end 

    #  q2subquestion

    def q2action
        # display action generes (using tty selector)
        # depending on what is selected create new Genre#
        prompt.select("Choose an action based genre:") do |menu|
            menu.choice "Thriller", -> {self.genre = "Thriller"}
            menu.choice "Crime", -> {}
            menu.choice "Adventure", -> {}
        end 

    end 

    def q2fantasy
        # display action generes (using tty selector)
        # depending on what is selected create new Genre#

        prompt.select("Choose a a fantasy based genre:") do |menu|
            menu.choice "Sci-Fi", -> {puts "test outcome2"}
            menu.choice "Animation", -> {}
            menu.choice "Superhero", -> {}
        end 

    end 

    def q2drama
        # display action generes (using tty selector)
        # depending on what is selected create new Genre#
        prompt.select("Choose a drama based genre:") do |menu|
            menu.choice "Romance", -> {"test outcome 3"}
            menu.choice "Mystery", -> {}
            menu.choice "Drama", -> {}
        end 

    end 

    def q2surprise
        # pick and display a random movie 
    end 

    def oneMovieToRuleThemAll
        # only recommends one of the LoTR movies
    end 

    def user_sign_in
        name = prompt.ask("Please enter your Username")
        if User.find_by(name: name)
            password = prompt.ask("Please enter your Password")
        binding.pry
            if User.find_by(password: password)
                questionnaire = Questionnaire.create(name: "TestQ") 
            else
                puts "Wrong password"
                self.welcome
            end
        else
            puts "Username does not exist. Please make account"
            self.welcome
        end
        self.q1 
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
end 

puts "TEST1.2.3"