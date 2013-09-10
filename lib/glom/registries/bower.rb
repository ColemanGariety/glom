require 'net/http'
require 'json'

module Glom::Bower
  KEYWORDS = ['bower', 'front-end', 'frontend', 'js', 'javascript']
  URL = 'bower.io'
  
  def self.get(query)
	  puts "Searching #{URL} for '#{query}'..."
	  
	  uri = URI('https://bower-component-list.herokuapp.com')
    res = Net::HTTP.get(uri)
    JSON.parse(res)
  end
end