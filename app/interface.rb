require 'pry'

class Interface

    attr_reader :prompt, :title
    attr_accessor :questionnaire, :user, :search_term, :genre

    def initialize
        @prompt = TTY::Prompt.new
    end 

    def run
        welcome
        sleep(0.3)
        menu 
        # MENU: Choose from Category / Genre, Provide a search term, RANDOM MOVIE! / SETTINGS-Sep method 
        system("clear")
        return_movie(self.genre)
        system("clear")
        again 
    end 

    def run_2
        menu 
        system("clear")
        return_movie(self.genre)
        system("clear")
        again 
    end 

    def welcome
        system("clear")
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
        '__88P' '88*888 Cb      Cb        88___/  '_88P    88_/      /      Y88b      /          Y888b  ""88_-~*      Y     888 688___/  
                          Y8""8D  Y8""8D                                                                                                 
                                                     Created by: Blaine Love and Matthew Aquino".colorize(:light_blue)
        sleep(2.2)
        # system("clear")
        prompt.select("Please select from the following") do |main|
            main.choice "Sign in", -> { user_sign_in }
            main.choice "Sign up", -> { user_sign_up }
            main.choice "Best movies?", -> { oneMovieToRuleThemAll }
            main.choice "Exit", -> { exit }
        end
    end 

    def user_sign_in
        sleep(1.5)
        system("clear")
        name = prompt.ask("Please enter your Username")
        if User.find_by(name: name)
            sleep(0.5)
            password = prompt.mask("Please enter your Password")
            system("clear")
            self.user = User.all.find_by(name: name, password: password)
            if User.find_by(password: password)
                self.questionnaire = Questionnaire.create(name: user.name, user_id: user.id) 
            else
                puts "Wrong password"
                welcome
            end
        else
            puts "Username does not exist. Please make account."
            sleep (3.5)
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
        system("clear")
        puts "Goodbye! Thanks for using our app!!!"
        sleep(2.5)
        system("clear")
        exit!
    end

    # MENU: Choose from Category / Genre, Provide a search term, RANDOM MOVIE! / SETTINGS-Sep method 

    #####-MENU-#####
    def menu
        system("clear")
        sleep(0.3)
        prompt.select('      *** MAIN MENU ***') do |menu|
            menu.choice "Choose from Category/Genre", -> {q1}
            menu.choice "Provide a search term", -> { questionnaire.update(q1answer: "search-term")
                query_term }
            menu.choice "Surpise me! (Random Movie)", -> { questionnaire.update(q1answer: "random-search")
                random_movie }    
            menu.choice "Settings", -> { settings }
            menu.choice "Exit", -> { exit }
        end 
    end 

    def query_term
        system("clear")
        self.search_term = prompt.ask("Please input a search term for your movie.")
        self.questionnaire.update(q2answer: search_term)
        self.genre = Genre.create(name: search_term, questionnaire_id: questionnaire.id) 

        update_term
    end 

    def update_term
        system("clear")
        prompt.select("You have inputted the following search term: #{questionnaire.q2answer}\nPlease confirm or update your choice.") do |menu|
            menu.choice "Confirm", -> { }
            menu.choice "Update", -> { query_term }
        end 

    end
    
    def random_movie
        system("clear")
        self.search_term = Genre.random_genre
        self.questionnaire.update(q2answer: search_term)
        self.genre = Genre.create(name: search_term, questionnaire_id: questionnaire.id) 

    end 

    def settings 
        system("clear")
        prompt.select(" *** SETTINGS ***") do |menu|
        menu.choice "See Favorites", -> { see_favorites }
        menu.choice "Delete Account", -> { delete_account }
    end 

    end 

    def see_favorites 
        user.favorites.split(',').each{|movie| sleep(0.3) 
            puts movie} if user.favorites 
        sleep(1.5)
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
        prompt.select("Press below to return to Main Menu") do |main|
            main.choice "BACK", -> { menu }
        end 
    end 

    def delete_account
        User.destroy(user.id)
        Questionnaire.where(user_id: user.id.to_s).destroy_all
        Movie.where(user_id: user.id).destroy_all
        sleep(0.5)
        puts "Your account has been deleted."
        sleep(1.5)
        run   
    end 



    #####Questionnaire##### 

    def q1
        system("clear")
        sleep(0.5)
        prompt.select("Choose a Category:") do |menu|
            menu.choice "Action", -> { questionnaire.update(q1answer: "Action")
                q2action}
            menu.choice "Drama", -> { questionnaire.update(q1answer: "Drama")
                q2drama}
            menu.choice "Fantasy", -> { questionnaire.update(q1answer: "Fantasy")
                q2fantasy}
        end 

        self.questionnaire.update(q2answer: self.search_term)
        self.genre = Genre.create(name: self.search_term, questionnaire_id: questionnaire.id) 

        update_choice
    end 

    def q2action
        # binding.pry
        system("clear")
        sleep(0.3)
        prompt.select("Choose an action based genre:") do |menu|
            menu.choice "Thriller", -> {self.search_term = "Thriller"}
            menu.choice "Crime", -> {self.search_term = "Crime"}
            menu.choice "Adventure", -> {self.search_term = "Adventure"}
        end 

    end 

    def q2fantasy
        system("clear")
        sleep(0.3)
        prompt.select("Choose a a fantasy based genre:") do |menu|
            menu.choice "Sci-Fi", -> {self.search_term = "Sci-Fi"}
            menu.choice "Animation", -> {self.search_term = "Animation"}
            menu.choice "Superhero", -> {self.search_term = "Superhero"}
        end 

    end 

    def q2drama
        system("clear")
        sleep(0.3)
        prompt.select("Choose a drama based genre:") do |menu|
            menu.choice "Romance", -> {self.search_term = "Romance"}
            menu.choice "Mystery", -> {self.search_term = "Mystery"}
            menu.choice "Drama", -> {self.search_term = "Drama"}
        end 

    end 

    def update_choice
        system("clear")
        prompt.select("You have selected the following...\nCategory: #{questionnaire.q1answer}\nGenre: #{questionnaire.q2answer}\nPlease confirm or update your choices.") do |menu|
            menu.choice "Confirm", -> { }
            menu.choice "Update", -> { q1 }
        end 

    end 

    def q2surprise
        
        # pick and display a random movie 
    end 

    def oneMovieToRuleThemAll
        system("clear")
        sleep(3)
        puts "The Lord of the Rings triology... Obviously"
        puts "`
        
                 ___ . .  _                                                                                             
        'T$$$P'   |  |_| |_                                                                                             
         :$$$     |  | | |_                                                                                             
         :$$$                                                      'T$$$$$$$b.                                          
         :$$$     .g$$$$$p.   T$$$$b.    T$$$$$bp.                   BUG    'Tb      T$b      T$P   .g$P^^T$$  ,gP^^T$$ 
          $$$    d^'      '^b  $$  'Tb    $$    'Tb    .s^s. :sssp   $$$     :$; T$$P $^b.     $   dP"     'T :$P     T
          :$$   dP         Tb  $$   :$;   $$      Tb  db   db $      $$$     :$;  $$  $  Tp    $  d$           Tbp.   
          :$$  :$;         :$; $$   :$;   $$      :$; T.   .P $^^    $$$    .dP   $$  $   ^b.  $ :$;            "T$$p.  
          $$$  :$;         :$; $$...dP    $$      :$;  **s**  $      $$$...dP     $$  $     Tp $ :$;     "T$$       T$b 
          $$$   Tb.       ,dP  $$"" Tb    $$      dP ""$""$" "$**^^  $$$""T$b     $$  $      ^b$  T$       T$ ;      $$;
          $$$    Tp._   _,gP   $$    Tb.  $$    ,dP    $  $...$ $..  $$$   T$b    :$  $       ^$   Tb.     :$ T.    ,dP 
          $$$;    "^$$$$$^"   d$$     T.d$$$$$P^"      $  $"""$ $"", $$$    T$b  d$$bd$b      d$b   "^TbsssP"  T$bgd$P  
          $$$b.____.dP                                 $ .$. .$.$ss,d$$$b.   T$b.                                       
        .d$$$$$$$$$$P'"                                                      'T$b.
        
        ".colorize(:yellow)
        
        sleep(5)
        system("clear")
        run 
        # only recommends one of the LoTR movies
    end 

    ###### SEEDED MOVIE -- MVP #####
    # def return_movie
    #     # using self.genre, return a movie and it's details
    #     gen_arr = Movie.all.select{|movie| movie.genre == self.search_term}
    #     movie_inst = gen_arr[rand(0..gen_arr.length-1)]
    #     binding.pry 
    #     puts "The movie chosen for you is #{movie_inst.name} and it has a rating of #{movie_inst.rating} stars with a feature length of #{movie_inst.length} minutes."
    # end 

    def return_movie(genre_inst)
        # binding.pry
        sampled_movie = genre_inst.get_movie_id_api
        new_movie = Movie.create(genre: genre_inst.name, imdb_id: sampled_movie)
        
        genre_inst.update(movie_id: new_movie.id)
        new_movie.update(user_id: questionnaire.user_id)
        
        new_movie.movie_metadata_api


        prompt.select("Would you like to add #{new_movie.name} to your favorites?") do |menu|
            menu.choice "Yes", -> { add_to_favorites}
            menu.choice "No", -> { }
        end 
        # binding.pry
    end 

    def add_to_favorites
        # binding.pry 

        # user_id = questionnaire.user_id.to_i 
        # u_inst = User.find(user_id)

        if user.favorites
            user.update( favorites: user.favorites + ",#{Movie.last.name}")
        else 
            user.update( favorites: Movie.last.name) 
        end 
    end 

    def again
        prompt.select("Would you like another movie suggested?") do |main|
            main.choice "One more try! (Brings you back to main menu.)", -> { run_2 }
            main.choice "No thanks.", -> { exit }
        end

    end 

end 
