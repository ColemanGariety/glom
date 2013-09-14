require 'net/http'
require 'json'
require 'time'
require 'glom/time/time_ago_in_words'

module Glom::Bower
  KEYWORDS = ['bower', 'front-end', 'frontend', 'js', 'javascript']
  NAME = 'bower'
  URL = 'https://bower-component-list.herokuapp.com'
  
  def standardize(query)
	  json = Glom.get(URL)
    
    packages = JSON.parse(json).select do |package|
      package['description'].include? query if package['description'].is_a? String
    end
    
    packages.map do |package|
      [package['name'], package['description'], package['owner'], package['stars'], Time.parse(package['updated']).time_ago_in_words, NAME]
    end
  end
end