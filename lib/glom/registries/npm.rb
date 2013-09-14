require 'net/http'
require 'json'
require 'rubygems'
require 'action_view'
require 'time'

module Glom::Npm
  KEYWORDS = ['npm', 'node', 'nodejs', 'js', 'javascript']
  NAME = 'npm'
  URL = 'http://jiyinyiyong.github.io/nipster/packages.json'
  
  def self.standardize(query)
    json = Glom.get(URL)
    
    packages = JSON.parse(json)['packages'].select do |package|
      package[1].include? query if package[1].is_a? String and package[3].is_a? String
    end

    packages.map do |package|
      [package[0], package[1], package[2], package[6], time_ago_in_words(Time.parse(package[3])), NAME]
    end
  end
end