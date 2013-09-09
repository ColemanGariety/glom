require "glom/version"
require "net/http"
require "json"

class Glom
  # glom [term] [language]
  # 1. Curl from bower-component-list.herokuapp.com, npmjs.org/package/[package], and rubygems.org/gems/[name]
  # 2. Parse JSON from bower to and direct to Github page for keyword matching
  # 3. Print results into a neat ASCII table

	def initialize(query)
	  case query[1].downcase
	  when 'rb', 'ruby'
	    urls = ['rubygems.org/gems']
	  when 'js', 'javascript'
	    urls = ['bower-component-list.herokuapp.com']
	  when 'node', 'nodejs'
	    urls = ['npmjs.org/package']
	  else
	    urls = ['rubygems.org/gems', 'bower-component-list.herokuapp.com', 'npmjs.org/package']
	  end
	  
	  Glom.search(urls)
	end
	
	def search(url)
	  # Array of packages returned
	  results = []
	  
	  urls.each do |url|
      uri = URI("http://#{url}")
      params = { :limit => 10, :page => 3 }
      uri.query = URI.encode_www_form(params)
      
      res = Net::HTTP.get_response(uri)
      results << JSON.parse(res.body) if res.is_a?(Net::HTTPSuccess)
    end
    
    results[0].each do |package|
      puts package['name']
    end
  end
end