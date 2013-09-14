require 'glom/version'
require 'net/http'
require 'json'
require 'tmpdir'

# Require individual registry logic
Dir["#{File.dirname __FILE__}/glom/registries/*.rb"].each do |file|
  require file
end

module Glom
  self.constants.each do |constant|
    constant = self.const_get constant
    (REGISTRIES ||= []) << constant if constant.is_a? Module
  end
  
	def detect(query)
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
	    include registry
	    
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
	  # Require terminal-table
    Dir["#{File.dirname __FILE__}/glom/terminal-table/*.rb"].each do |file|
      require file
    end
    
	  table = Terminal::Table.new
	  table.headings = ['Name', 'Description', 'Author', 'Stars', 'Last Updated', 'Registry']
	  table.rows = @packages[0..20]
	  table.style = {
  	  :width => `/usr/bin/env tput cols`.to_i
	  }
	  
	  puts ""
	  puts table
	end
	
	def get(address)
	  cache = "#{Dir.tmpdir}/#{address.gsub(/[\x00\/\\:\*\?\"<>\|]/, '_').gsub('.json', '')}.json"
	  
	  if File.exist? cache
      json = IO.read(cache)
    else
  	  url = URI.parse(address)
  	  
      http = Net::HTTP.new(url.host, url.port)
      if address =~ /^https/
        http.use_ssl = true
        # http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      end
      
      req = Net::HTTP::Get.new(url.request_uri)
      res = http.request(req)
      
      json = res.body
      
      output = File.new(cache, 'w')
      output.puts json
      output.close
    end
    
    return json
	end
end