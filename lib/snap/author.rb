class Snap::Author
    attr_accessor :name, :works_count, :about
    attr_reader :id, :books, :gender, :link

    @@all = []
    @@fave_authors = [] # A user can add a favorite author

    def initialize(author_info, full_info_provided = false) # If searched for by name, most of the info will be missing, so another api call needs to be made
        @books = []
        @id = author_info.id
        @name = author_info.name 
        @link = author_info.link
        @@all << self
        if full_info_provided
            @gender = author_info.gender
            @works_count = author_info.works_count
            @about = author_info.about
            self.books = author_info.books.book
        else
            attributes = get_attributes # If searched for by name, a different api call needs to be made to get other info
            set_attributes(attributes)
        end
    end 

    def get_attributes
        Snap::Api.author_info(self.id)
    end

    def set_attributes(attributes)
        @gender = attributes.gender
        self.works_count = attributes.works_count
        self.about = attributes.about
        self.books = attributes.books.book
    end

    def books=(books)
        books.each do |book|
            book = Snap::Book.find_or_create(book)
            book.author = self
            @books << book unless @books.include?(book)
        end
    end

    def gender_pronoun
        pronoun = nil
        if self.gender == "male"
            pronoun = "his"
        elsif self.gender == "female"
            pronoun = "her"
        else
            pronoun = "his/her" # Just in case the gender isn't provided for whatever reason
        end
    end

    def add_to_favorites
        @@fave_authors << self unless @@fave_authors.include?(self)
    end

    def self.find_or_create(attributes)
        author = self.author_already_exists?(attributes.id)
        author = self.new(attributes) if !author
        author
    end

    def self.author_already_exists?(id)
        self.all.find { |author| author.id == id }
    end
    
    def self.all
        @@all 
    end

    def self.fave_authors
        @@fave_authors
    end
end