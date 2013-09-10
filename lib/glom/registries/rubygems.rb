require 'net/http'

module Glom::Rubygems
  KEYWORDS = ['ruby', 'rb', 'rubygem', 'gem']
  URL = 'rubygems.org'

  def self.get(query)
	  puts "Searching #{URL} for '#{query}'..."
  end
end