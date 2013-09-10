# 1. `glom [@string]`
# 2. (initialize) Use environment-specific keywords from @string to get an array of @registries to search
# 3. (search) Search for @string in each of the @registries and join the results
# 4. (sort) Sort the JSON by ((stars * followers of top contributor) / issues)
# 5. (display) Print [title], [description], [top contributor], [stars], and [install command] into an ASCII table in terminal

require "glom/version"
require 'glom/registries'
require "net/http"
require "json"

class Glom
	def initialize
	  @query = ARGV[0].dup
	
	  REGISTRIES.each do |registry, keywords|
	    keywords.each do |keyword|
	      if ARGV[0].include? keyword
	        (@registries ||= []) << registry
	        @query.slice! keyword
	        @query.strip!
	      end
	    end
	  end
	  
	  if defined? @registries then search @registries
	  else search REGISTRIES end
	end
	
	def search(registries)
	  registries.each do |registry|
	    puts "search for '#{@query}' in #{registry} "
	  end
	end
	
	def sort
	end
	
	def display
	end
end