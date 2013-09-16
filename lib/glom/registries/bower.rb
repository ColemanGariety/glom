require 'json'
require 'time'
require 'glom/time/time_ago_in_words'

module Glom::Bower
  KEYWORDS = ['bower', 'front-end', 'frontend', 'js', 'javascript', 'client-side', 'clientside']
  NAME = 'bower'
  URL = 'https://bower-component-list.herokuapp.com'
  BLACKLIST = []
  
  def standardize(query)
	  json = Glom.get(URL)
    
    packages = JSON.parse(json).select do |package|
      Glom.match(package['name'], package['description'], query) > 0 and !BLACKLIST.include?(package['name'].downcase) if package['description'].is_a? String
    end
    
    packages.map do |package|
      [package['name'], package['description'], package['owner'], package['stars'], Time.parse(package['updated']).time_ago_in_words, NAME, Glom.match(package['name'], package['description'], query)]
    end
  end
end