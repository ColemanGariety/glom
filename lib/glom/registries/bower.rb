require 'net/http'
require 'json'
require 'rubygems'
require 'action_view'
require 'time'
require 'tmpdir'

include ActionView::Helpers::DateHelper

module Glom::Bower
  KEYWORDS = ['bower', 'front-end', 'frontend', 'js', 'javascript']
  URL = 'bower.io'
  
  def self.get(query)
	  cache = "#{Dir.tmpdir}/bower.json"
	  
	  if File.exist? cache
      json = IO.read(cache)
    else
  	  uri = URI('https://bower-component-list.herokuapp.com')
      json = Net::HTTP.get(uri)
      
      File.open(cache,"w") do |file|
        file.write(json)
      end
    end
    
    packages = JSON.parse(json).select do |package|
      package['description'].include? query if package['description'].is_a? String
    end
    
    packages.map do |package|
      [package['name'], package['description'], package['owner'], package['stars'], time_ago_in_words(Time.parse(package['updated'])), 'bower']
    end
  end
end