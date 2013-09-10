require "glom/version"
require 'glom/registries'
require "net/http"
require "json"

class Glom
	def initialize(query)
	  REGISTRIES.each do |registry, keywords|
	    keywords.each do |keyword|
	     (@registries ||= []) << registry if query[0].include? keyword
	    end
	  end
	end
	
	def search
	end
	
	def filter
	end
	
	def sort
	end
	
	def display
	end
end