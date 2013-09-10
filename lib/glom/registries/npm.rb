require 'net/http'

module Glom::Npm
  KEYWORDS = ['npm', 'node', 'nodejs', 'js', 'javascript']
  URL = "npmjs.org"

  def self.get(query)
	  puts "Searching npm registry for '#{query}'..."
  end
end