require 'goodreads'
require 'pry'

KEY = "T5jCRWzUGCZkMLVcFhO0w"
SECRET = "E0W0bdU4o4cGP0C3tYpRVl5njXZhC1VU3RIcurNG0o"
CLIENT = Goodreads.new(api_key: KEY)

class Snap::Api
    def self.books_by_author(author_name)
        CLIENT.author_by_name(author_name)
    end

    def self.author_info(author_id)
        CLIENT.author(author_id)
    end

    def self.books_by_name(name)
        puts 'books by name'
    end

end