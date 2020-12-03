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
        number_of_titles = 0
        list.each_with_index do |book, i|
            print_info(book, i)
            number_of_titles = i + 1
            break if i == limit - 1 # We want to limit the number of results to the "limit" variable
        end
        @number_of_titles = number_of_titles
    end

    def options 
        choice = gets.chomp

        if choice == "1" # By author name
            author_info = Snap::Api.books_by_author('j')
            author = Snap::Author.new(author_info)
            display_books(author.books)
        elsif choice == "2" #By book name
            Snap::Api.books_by_name('lord')
        elsif choice == "3" # Show favorite author(s)
            display_favorite_authors
        elsif choice == "4" # Show favorite book(s)
            display_favorite_books
        end

        if choice == "1" || choice == "2"
            selection = more_details?(@number_of_titles) # Gives user the option to look at a title in more detail
            detailed_info(author.books[selection]) if selection
        end
        choice
    end

    def more_details?(number_of_titles)
        puts "If something catches your eye, please put the number of the title and press return. If not, type 'exit'"
        choice = nil
        selection = nil
        while choice != "exit"
            choice = gets.chomp
            if is_numeric?(choice) 
                choice = choice.to_i # If a float was entered, it will be floored to an int
                if choice > 0 && choice <= number_of_titles
                    selection = choice - 1 # selection now corresponds to index
                    choice = "exit"
                else
                    puts "The number must correspond to one of the titles."
                end 
            else
                puts "The choice must be a number corresponding to the title."
            end
        end 
        selection
    end

    def display_favorite_authors
        Snap::Author.fave_authors.each do |author| # scrolling through each favorite author object
            gender_pronoun = author.gender_pronoun
            print "#{author.name} and some of #{gender_pronoun} material: "
            author.books.each_with_index do |book, i| # scrolling though each of the author's books
                print "\n" if i % 2 == 0
                print "#{i+1}. #{book.title}\t\t"
            end
            print "\n"
        end
    end

    def display_favorite_books
        Snap::Book.fave_books.each do |book|
            binding.pry
            puts "#{book.title}"
        end
    end

    def detailed_info(book) # Detailed info displayes the full description along with some other attributes
        print_info(book, nil, true)
        book.author.add_to_favorites if favorite?("author") 
        book.add_to_favorites if favorite?("book")
    end

    def favorite?(type)
        puts "Add the #{type} to your favorites list? (y/n)"
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

    private

    def greeting
        puts "Please select the option you want - (type 'exit' to quit)"
        puts "1. Bring up books by an author."
        puts "2. Search for books by name."
        puts "3. View my favorite authors and some of their works."
        puts "4. View my favorite books."
    end

    def print_info(book, index = nil, full = false)
        truncate_amount = full ? 5000 : 300 # show full description if closer detail or truncated if partial
        index = index == nil ?  '' : "#{index + 1}. "
        isbn = book.isbn == nil ? "N/A" : book.isbn
        puts "#{index}Title - #{book.title}\n\nAuthor - #{book.author.name}\n\n"
        puts "Description - \n#{book.description.gsub(/<.*>/, ' ').truncate(truncate_amount)}\n\n" #gsub first because some tags fall through the cracks at the end otherwise
        puts "Rating - #{book.rating} Rating Count - #{book.ratings_count}\n\n"
        puts "Goodreads Link - #{book.link}\n\n"
        puts "ISBN - #{isbn}  Number of pages - #{book.num_pages}" if full
        puts "Publisher - #{book.publisher}\n"
        puts "----------------------------------------------------------------------------------------------------------\n\n"
    end

    def is_numeric?(string)
        true if Float(string) rescue false
    end
end

# @id=136251,
#       @isbn="0545010225",
#       @link="https://www.goodreads.com/book/show/136251.Harry_Potter_and_the_Deathly_Hallows",
#       @num_pages="759",
#       @publisher="Arthur A. Levine Books / Scholastic Inc.",
#       @rating="4.62",
#       @ratings_count="2833444",
#       @title="Harry Potter and the Deathly Hallows (Harry Potter, #7)">,
#      #<Snap::Book:0x0000560645fa32b8
#       @author=#<Snap::Author:0x00005606460b6b28 ...>,
#       @description=