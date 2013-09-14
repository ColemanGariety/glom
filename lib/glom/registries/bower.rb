require 'net/http'
require 'json'
require 'rubygems'
require 'action_view'
require 'time'

include ActionView::Helpers::DateHelper

module Glom::Bower
  KEYWORDS = ['bower', 'front-end', 'frontend', 'js', 'javascript']
  NAME = 'bower'
  URL = 'https://bower-component-list.herokuapp.com'
  
  def self.standardize(query)
	  json = Glom.get(URL)
    
    packages = JSON.parse(json).select do |package|
      package['description'].include? query if package['description'].is_a? String
    end
    
    packages.map do |package|
      [package['name'], package['description'], package['owner'], package['stars'], time_ago_in_words(Time.parse(package['updated'])), NAME]
    end
  end
end