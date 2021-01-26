

class Interface

    attr_reader :prompt

    def initialize
        @prompt = TTY::Prompt.new
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
        # name = prompt.ask("Please enter your Username")
        # while User.find_by(name: name)
        #     password = prompt.ask("Please enter your Password")
        # else 
        #     puts "Username does not exist"
        #     name = prompt.ask("Please enter your Username")
        # end
        Questionnaire.create
    end

    def user_sign_up
        name = prompt.ask("Please enter your new Username")
        while User.find_by(name: name)
            puts "Account already ctreated with this name"
            name = prompt.ask("Please enter your new Username")
        end 
        password = prompt.mask("Please enter your new Password")
        User.create(name: name, password: password)
        self.welcome
    end

    def exit
        puts "Goodbye, Thanks for using Lord of the Movies"
    end
end 

puts "TEST1.2.3"