require 'net/http'

module Glom::Npm
  KEYWORDS = ['npm', 'node', 'nodejs', 'js', 'javascript']
  URL = "npmjs.org"
  
  def self.get(query)
	  puts "Searching #{URL} for '#{query}'..."
	  
	  uri = URI('https://registry.npmjs.org/-/all/')
    res = Net::HTTP.get(uri)
    
    packages = JSON.parse(res).select do |package|
      package['description'].include? query if package['description'].is_a? String
    end
    
    packages.map do |package|
      [package['name'], package['description'], package['owner'], package['stars'], 'bower']
    end
  end
end