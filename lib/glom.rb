##
# 
# Title: Glom
# Author: Jackson Gariety
# Description: Intelligent package search, inside your shell.
# 
# 1. `glom [@string]`
# 2. (initialize) Use environment-specific keywords from @string to get an array of @registries to search
# 3. (search) Search for @string in each of the @registries and join the results
# 4. (sort) Sort the JSON by (stars), and maybe ((stars * followers of top contributor) / issues) in the future
# 5. (display) Print [title], [description], [top contributor], [stars], and [install command] into an ASCII table in terminal
#
# 1. `glom update`
# 2. Retreive the latest version of the JSON files
#
##

require 'glom/version'
require 'json'
require 'tmpdir'

# Require individual registry logic
Dir["#{File.dirname __FILE__}/glom/registries/*.rb"].each do |file|
  require file
end

# Require terminal-table
Dir["#{File.dirname __FILE__}/glom/terminal-table/*.rb"].each do |file|
  require file
end

class Glom
  self.constants.each do |constant|
    constant = self.const_get constant
    (REGISTRIES ||= []) << constant if constant.is_a? Module
  end
  
	def initialize(query)
	  @query = query.dup
	
	  REGISTRIES.each do |registry|
	    registry::KEYWORDS.each do |keyword|
	      if query.include? keyword
	        (@registries ||= []) << registry
	        @query.slice! keyword
	        @query.strip!
	      end
	    end
	  end
	  
	  @registries = REGISTRIES unless defined? @registries
	end

	def search
	  @registries.each do |registry|
	    puts "\nSearching `#{registry::URL}` for `#{@query}`...\n"
	    (@packages ||= []).concat registry.standardize(@query)
	  end
	end
	
	def sort
	  @packages.sort_by! do |package|
	    -package[3]
	  end
	end
	
	def display
	  table = Terminal::Table.new
	  table.headings = ['name', 'description', 'author', 'stars', 'updated']
	  table.rows = @packages
	  table.style = {
  	  :width => `/usr/bin/env tput cols`.to_i
	  }
	  
	  puts ""
	  puts table
	end
	
	def self.get(address)
	  cache = "#{Dir.tmpdir}/#{address.gsub(/[\x00\/\\:\*\?\"<>\|]/, '_')}.json"
	  
	  if File.exist? cache
      json = IO.read(cache)
    else
  	  uri = URI(address)
      json = Net::HTTP.get(uri)
      
      output = File.new(cache, 'w')
      output.puts json
      output.close
    end
    
    return json
	end
end