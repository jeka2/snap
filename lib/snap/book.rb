require 'pry'

class Snap::Book
   
    attr_accessor :title, :author, :id, :isbn, :num_pages, :link, :publisher, :rating, :ratings_count, :description

    @@all = []
    @@fave_books = [] # A user can add a favorite book that persist for the duration of the runtime

    def initialize(attributes, author_set = false)
        @id = attributes[:id]
        @isbn = attributes[:isbn]
        @title = attributes[:title]
        @num_pages = attributes[:num_pages]
        @link = attributes[:link]
        @publisher = attributes[:publisher]
        @rating = attributes[:rating]
        @ratings_count = attributes[:ratings_count]
        @description = attributes[:description]
        @@all << self
        
        set_author(attributes[:authors][:author]) if !author_set # Author will not be initially set if user looked up by book
    end

    def set_author(authors) 
        author_id = authors.is_a?(Array) ? authors[0][:id] : authors[:id] # A book can have several authors, we'll only pick the first one
        author = Snap::Author.author_already_exists?(author_id)
        unless author
            author_info = Snap::Api.author_info(author_id)
            author = Snap::Author.new(author_info, true)
        end
        self.author = author
    end

    def add_to_favorites
        @@fave_books << self unless @@fave_books.include?(self)
    end

    def self.find_or_create(attributes)
        book = self.all.find { |b| b.id == attributes.id }
        book = self.new(attributes) if !book
        book
    end

    def self.book_already_exists?(id)
        self.all.find { |book| book.id == id }
    end 

    def self.all
        @@all
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