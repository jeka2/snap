require 'pry'

class Snap::Book

    attr_accessor :name, :author

    def initialize(name = nil, book = nil)
        if book 
            
        else
            @name = name
        end
    end

    def self.get_book

    end
end



        # uri = URI('https://www.goodreads.com/search/index.xml')
        # params = { q: "9780345015339", key: KEY, page: 1 }
        # uri.query = URI.encode_www_form(params)
        
        # res = Net::HTTP.get_response(uri)
        # noko = Nokogiri.XML(res.body, nil, nil, Nokogiri::XML::ParseOptions.new((1 << 0) | (1 << 1)))