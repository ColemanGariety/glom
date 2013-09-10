require 'net/http'

class Glom::Npm
  KEYWORDS = ['npm', 'node', 'nodejs', 'js', 'javascript']

  def initialize(query)
	  puts "Searching for '#{query}' in npm..."
  end
end