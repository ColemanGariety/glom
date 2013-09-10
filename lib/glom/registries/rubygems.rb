require 'net/http'

class Glom::Rubygems
  KEYWORDS = ['ruby', 'rb', 'rubygem', 'gem']
  URL = 'rubygems.org'

  def initialize(query)
	  puts "Searching #{URL} for '#{query}'..."
  end
end