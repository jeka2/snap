class Snap::CLI

    def call
        list_info
    end

    def list_info
        choice = nil
        while choice != "exit"
            greeting
            choice = self.options
        end
    end

    def display_books(list, limit = 10)
        list.each_with_index do |book, i|
            puts "#{i+1}. Title - #{book.title}\n\nAuthor - #{book.author.name}\n\n"
            puts "Description - \n#{book.description.gsub(/<.*>/, ' ').truncate(300)}\n\n" #gsub first because some tags fall through the cracks at the end 
            puts "Rating - #{book.rating} Rating Count - #{book.ratings_count}\n\n"
            puts "Goodreads Link - #{book.link}\n\n"
            puts "Publisher - #{book.publisher}\n"
            puts "----------------------------------------------------------------------------------------------------------\n\n"
            break if i == limit - 1 # We want to limit the number of results to the "limit" variable
        end
        more_details?(limit - 1)
    end

    def options 
        choice = gets.chomp

        if choice == "1"
            author_info = Snap::Api.books_by_author('j')
            author = Snap::Author.new(author_info)
            display_books(author.books)
        elsif choice == "2"
            Snap::Api.books_by_name('lord')
        end
        choice
    end

    def favorite_author?
        puts "Add the author to your favorites list? (y/n)"
        choice = nil
        while choice != "picked"
            selection = gets.chomp.downcase
            if selection == 'y' || selection == 'n'
                choice = "picked" 
            else
                puts "Please enter either the 'y' key or the 'n' key."
            end
        end
        selection == 'y' ? true : false
    end

    def more_details?(number_of_titles)
        puts "If something catches your eye, please put the number of the title and press return."
        
    end

    private

    def greeting
        puts "Please select the option you want - (type 'exit' to quit)"
        puts "1. Bring up books by an author."
        puts "2. Search for books by name."
        puts "3. View my favorite authors."
        puts "4. View my favorite books."
    end

    def format

    end
end