require 'pry'
require 'goodreads'

KEY = "T5jCRWzUGCZkMLVcFhO0w"
SECRET = "E0W0bdU4o4cGP0C3tYpRVl5njXZhC1VU3RIcurNG0o"

class Snap::Book
    def self.get_book
        client = Goodreads.new(api_key: KEY) # short version
        
        binding.pry
    end
end



        #uri = URI('https://www.goodreads.com/search/index.xml')
        #params = { q: "9780345015339", key: KEY, page: 1 }
        #uri.query = URI.encode_www_form(params)
        
        #res = Net::HTTP.get_response(uri)
        #noko = Nokogiri.XML(res.body, nil, nil, Nokogiri::XML::ParseOptions.new((1 << 0) | (1 << 1)))