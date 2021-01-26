require 'pry'

class Interface

    attr_reader :prompt
    attr_accessor :questionnaire 

    def initialize
        @prompt = TTY::Prompt.new
    end 

    def welcome
        puts 'WELCOME!'
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
        binding.pry
    end 

    #  q2subquestion

    def q2action
        # display action generes (using tty selector)
        # depending on what is selected create new Genre#
        prompt.select("Choose an action based genre:") do |menu|
            menu.choice "Thriller", -> {"test outcome"}
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

end 

puts "TEST1.2.3"