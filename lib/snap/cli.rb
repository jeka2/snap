class Snap::CLI

    def call
        list_info
        menu
        goodbye
    end

    def list_info
        puts <<-DOC
            1. Stuff
            2. More Stuff
            3. Even More Stuff
        DOC
    end

    def menu 
        Snap::Book.get_book
    end

    def get_genre
        
    end

    def get_timeframe

    end

    def goodbye

    end
end