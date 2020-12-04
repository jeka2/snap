require 'goodreads'
require 'pry'

class Snap::Api
    def self.books_by_author(author_name)
        client.author_by_name(author_name)
    end

    def self.author_info(author_id)
        client.author(author_id)
    end

    def self.books_by_name(name)
        puts 'books by name'
    end

    def self.client
        key = "T5jCRWzUGCZkMLVcFhO0w"
        secret = "E0W0bdU4o4cGP0C3tYpRVl5njXZhC1VU3RIcurNG0o"
        Goodreads.new(api_key: key)
    end

end