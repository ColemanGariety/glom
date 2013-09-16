require 'json'
require 'time'
require 'glom/time/time_ago_in_words'

module Glom::Npm
  KEYWORDS = ['npm', 'node', 'nodejs', 'js', 'javascript', 'server-side', 'serverside', 'back-end']
  NAME = 'npm'
  URL = 'http://jiyinyiyong.github.io/nipster/packages.json'
  BLACKLIST = ['jinja.js', 'joyentexpress']
  
  def standardize(query)
    json = Glom.get(URL)
    
    packages = JSON.parse(json)['packages'].select do |package|
      Glom.match(package[0], package[1], query) > 0 and !BLACKLIST.include?(package[0].downcase) if package[1].is_a? String and package[3].is_a? String and !package[5].nil?
    end

    packages.map do |package|
      [package[0], package[1], package[2], package[5], Time.parse(package[3]).time_ago_in_words, NAME, Glom.match(package[0], package[1], query) + 1]
    end
  end
end