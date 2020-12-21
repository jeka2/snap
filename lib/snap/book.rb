require 'pry'

class Snap::Book
   
    attr_accessor :title, :author, :id, :isbn, :num_pages, :link, :publisher, :rating, :ratings_count, :description

    @@all = []
    @@fave_books = [] # A user can add a favorite book that persist for the duration of the runtime

    def initialize(args, author_set = false)
        @id = args.delete("id").to_i

        args.each do |k, v| 
            self.send("#{k}=", v) if respond_to?(k) # There will be more arguments than we need, so we only want to grab the ones defined
        end

        @@all << self
        
        set_author(args[:authors][:author]) if !author_set # Author will not be initially set if user looked up by book
    end

    def set_author(authors) 
        author_id = authors.is_a?(Array) ? authors[0][:id] : authors[:id] # A book can have several authors, we'll only pick the first one
        author = Snap::Author.author_already_exists?(author_id)
        unless author # If the author with that id already exists, we don't need another one
            author_info = Snap::Api.author_info(author_id)
            author = Snap::Author.new(author_info, true)
        end
        self.author = author
    end

    def add_to_favorites
        @@fave_books << self unless @@fave_books.include?(self)
    end

    def self.find_or_create(attributes)
        book = self.book_already_exists?(attributes.id)
        book = self.new(attributes) if !book
        book
    end

    def self.book_already_exists?(id)
        self.all.find { |book| book.id == id.to_i }
    end 

    def self.all
        @@all
    end

    def self.fave_books
        @@fave_books
    end
end