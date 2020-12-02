require 'goodreads'
require 'pry'

KEY = "T5jCRWzUGCZkMLVcFhO0w"
SECRET = "E0W0bdU4o4cGP0C3tYpRVl5njXZhC1VU3RIcurNG0o"
CLIENT = Goodreads.new(api_key: KEY)

class Snap::Api
    def self.books_by_author(author_name)
        author_info = CLIENT.author_by_name(author_name)
        author = Snap::Author.new(author_info)
        puts author.name
    end

    def self.author_info(author)
        author_info = CLIENT.author(author.id)
        author.set_attributes(author_info)
    end

    def self.books_by_name(name)
        puts 'books by name'
    end

end