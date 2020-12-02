class Snap::Author

    attr_accessor :name, :link, :works_count, :about
    attr_reader :id, :books

    @@fave_authors = [] # A user can add a favorite author

    def initialize(author)
        @id = author.id
        @name = author.name 
        @link = author.link
        @books = []
        attributes = get_attributes # If searched for by name, a different api call needs to be made to get other info
        set_attributes(attributes)
    end 

    def get_attributes
        Snap::Api.author_info(self.id)
    end

    def set_attributes(attributes)
        self.works_count = attributes.works_count
        self.about = attributes.about
        self.books = attributes.books.book
    end

    def books=(books)
        books.each do |book|
            attributes = {}
            attributes[:id] = book.id
            attributes[:isbn] = book.isbn
            attributes[:title] = book.title
            attributes[:num_pages] = book.num_pages
            attributes[:link] = book.link
            attributes[:publisher] = book.publisher
            attributes[:rating] = book.average_rating
            attributes[:ratings_count] = book.ratings_count 
            attributes[:description] = book.description

            book = Snap::Book.new(nil, attributes)
            book.author = self
            @books << book
        end
    end

    def add_to_favorites
        @@fave_authors << self
    end
end