class Snap::Author

    attr_accessor :name, :link

    def initialize(author)
        @name = author.name 
        @link = author.link
    end 
end