class Interface

    attr_reader :prompt

    def initialize
        @prompt = TTY::Prompt.new
    end 

    def welcome
        puts 'WELCOME!'
    end 
end 

puts "TEST1.2.3"