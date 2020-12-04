require 'pry'

class Snap::Book
   
    attr_accessor :title, :author, :id, :isbn, :num_pages, :link, :publisher, :rating, :ratings_count, :description

    @@fave_books = [] # A user can add a favorite book that persist for the duration of the runtime

    def initialize(name = nil, book = nil)
        if book 
            @id = book[:id]
            @isbn = book[:isbn]
            @title = book[:title]
            @num_pages = book[:num_pages]
            @link = book[:link]
            @publisher = book[:publisher]
            @rating = book[:rating]
            @ratings_count = book[:ratings_count]
            @description = book[:description]
        else
            @name = name
        end
    end

    def add_to_favorites
        @@fave_books << self unless @@fave_books.include?(self)
    end

    def self.fave_books
        @@fave_books
    end
end

# attributes = {}
#             attributes[:id] = book.id
#             attributes[:isbn] = book.isbn
#             attributes[:title] = book.title
#             attributes[:num_pages] = book.num_pages
#             attributes[:link] = book.link
#             attributes[:publisher] = book.publisher
#             attributes[:rating] = book.average_rating
#             attributes[:ratings_count] = book.ratings_count 
#             attributes[:description] = book.description