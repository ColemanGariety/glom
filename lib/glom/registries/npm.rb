require 'net/http'
require 'json'
require 'rubygems'
require 'action_view'
require 'time'
require 'glom/time/time_ago_in_words'

module Glom::Npm
  KEYWORDS = ['npm', 'node', 'nodejs', 'js', 'javascript']
  NAME = 'npm'
  URL = 'http://jiyinyiyong.github.io/nipster/packages.json'
  
  def standardize(query)
    json = Glom.get(URL)
    
    packages = JSON.parse(json)['packages'].select do |package|
      package[1].downcase.include? query.downcase if package[1].is_a? String and package[3].is_a? String and !package[5].nil?
    end

    packages.map do |package|
      [package[0], package[1], package[2], package[5], Time.parse(package[3]).time_ago_in_words, NAME]
    end
  end
end