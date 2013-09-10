require 'net/http'

class Glom::Bower
  KEYWORDS = ['bower', 'front-end', 'frontend', 'js', 'javascript']
  
  def initialize(query)
	  puts "Searching for '#{@query}' in bower..."
  end
end