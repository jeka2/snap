class Snap::CLI

    def call
        list_info
        menu
        goodbye
    end

    def list_info
        choice = nil
        while choice != "exit"
            puts "Please select how you would like to search"
            puts "1. Bring up books by an author."
            puts "2. Search for books by name"
            choice = gets.chomp

            if choice == "1"
                Snap::Api.books_by_author('james')
            elsif choice == "2"
                Snap::Api.books_by_name('lord')
            end
        end
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