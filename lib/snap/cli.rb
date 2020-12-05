class Snap::CLI

    def call
        list_info
    end

    def list_info
        choice = nil
        while choice != "exit" # main loop
            main_prompt
            choice = self.select_option
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

    def select_option 
        choice = gets.chomp
        books_to_display = nil

        if choice == "1" || choice == "2" # Search by author name or book title
            books_to_display = query_api_by_choice(choice)
        elsif choice == "3" # Show favorite author(s)
            display_favorite_authors
        elsif choice == "4" # Show favorite book(s)
            display_favorite_books
        elsif choice != "exit"
            puts "Please pick from the selection or type 'exit' to quit."
        end

        print "\n\n"

        if books_to_display
            if books_to_display.size == 1 # If there was only a single result, show the full details of the book
                detailed_info(books_to_display[0])
            else
                display_books(books_to_display)
                selection = more_details?(@number_of_titles) # Gives user the option to look at a title in more detail
                detailed_info(books_to_display[selection]) if selection
            end
        end
        choice
    end

    def query_api_by_choice(choice)
        valid_answer = false
        books_to_display = nil

        while !valid_answer
            valid_answer = true

            if choice == '1'
                puts "Enter the name of the author: "
                name = gets.chomp
                begin
                    author_info = Snap::Api.books_by_author(name)
                    books_to_display = create_authors_and_their_books(author_info, 'author')
                rescue => e # If an error occurs, the loop will continue
                    puts "The name you entered doesn't match our data. Please try again.\n"
                    valid_answer = false
                end
            elsif choice == '2'
                puts "Enter the title of the book: "
                title = gets.chomp
                begin 
                    book_info = Snap::Api.books_by_title(title)
                    books_to_display = create_authors_and_their_books(book_info, 'book') 
                rescue => e
                    puts "The title you entered doesn't match our data. Please try again.\n"
                    valid_answer = false
                end
            end
        end
        books_to_display
    end

    def create_authors_and_their_books(api_info, search_type)
        raise "Wrong #{search_type} name entered. " if api_info == {} # If api_info is an empty hash, the information the user entered is off, and no further action should be taken this loop

        book_list = nil
        if search_type == "author"
            author = Snap::Author.find_or_create(api_info)
            book_list = author.books
        elsif search_type == "book"
            book_list = Snap::Book.find_or_create(api_info)
        end
        Array(book_list) # Forces an encompassing by array
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
            elsif choice != "exit"
                puts "The choice must be a number corresponding to the title."
            end
        end 
        selection
    end

    def display_favorite_authors
        Snap::Author.fave_authors.each do |author| # scrolling through each favorite author object
            gender_pronoun = author.gender_pronoun
            print "\n#{author.name} and some of #{gender_pronoun} material: "
            author.books.each_with_index do |book, i| # scrolling though each of the author's books
                print "\n" if i % 2 == 0
                print "#{i+1}. #{book.title}\t\t"
            end
            puts "\nAbout author: \n#{author.about.gsub(/<.*>/, ' ')}\n\n"
        end
    end

    def display_favorite_books
        Snap::Book.fave_books.each do |book|
            puts "#{book.title}\n"
        end
        print "\n\n"
    end

    def detailed_info(book) # displays the full description along with some other attributes for a single book
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

    def main_prompt
        puts "Please select the option you want - (type 'exit' to quit)"
        puts "1. Search for books by author's name."
        puts "2. Search for books by title."
        puts "3. View my favorite authors and some of their works."
        puts "4. View my favorite books."
    end

    def print_info(book, index = nil, full = false)
        truncate_amount = full ? 5000 : 300 # show full description if closer detail or truncated if partial
        index = index == nil ?  '' : "#{index + 1}. "
        isbn = (book.isbn == nil || book.isbn == '') ? "N/A" : book.isbn
        puts "#{index}Title - #{book.title}\n\nAuthor - #{book.author.name}\n\n"
        puts "Description - \n#{book.description.gsub(/<.*>/, ' ').truncate(truncate_amount)}\n\n" if book.description #gsub first because some tags fall through the cracks at the end otherwise
        puts "Rating - #{book.rating} Rating Count - #{book.ratings_count}\n\n"
        puts "Goodreads Link - #{book.link}\n\n"
        puts "ISBN - #{isbn} Number of pages - #{book.num_pages}"
        puts "Publisher - #{book.publisher}\n" if book.publisher
        puts "----------------------------------------------------------------------------------------------------------\n\n"
    end

    def is_numeric?(string)
        true if Float(string) rescue false
    end
end
