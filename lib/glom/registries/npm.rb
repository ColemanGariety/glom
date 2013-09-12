require 'net/http'
require 'json'
require 'rubygems'
require 'action_view'
require 'time'

module Glom::Npm
  KEYWORDS = ['npm', 'node', 'nodejs', 'js', 'javascript']
  URL = "npmjs.org"
  
  def self.get(query)
	  cache = "#{Dir.tmpdir}/npm.json"
	  
	  if File.exist? cache
      json = IO.read(cache)
    else
  	  uri = URI('http://registry.npmjs.org/-/all/')
      json = Net::HTTP.get(uri)
      
      File.open(cache,"w") do |file|
        file.write(json)
      end
    end
    
    packages = JSON.parse(json)
    packages.delete('_updated')
    
    packages = packages.select do |name, package|
      unless package['keywords'].nil? or !package['repository'].is_a?(Hash)
        if package['repository']['url'] =~ /git:\/\/github.com/ or package['repository']['url'] =~ /git@github.com/ or package['repository']['url'] =~ /http(s):\/\/github.com/
          if package['keywords'].is_a? String
            package['keywords'].include? query
          else
            package['keywords'].select { |keyword| keyword.include? query }.any?
          end
        end
      end
    end
    
    packages.each do |package|
      unless package[1]['repository'].nil?
        if package[1]['repository']['url'] =~ /git:\/\/github.com/
          param = package[1]['repository']['url'].sub('git://github.com/', '')
        elsif package[1]['repository']['url'] =~ /git@github.com/
          param = package[1]['repository']['url'].sub(/git@github.com(:)/, '')
        elsif package[1]['repository']['url'] =~ /http(s):\/\/github.com/
          param = package[1]['repository']['url'].sub(/http(s):\/\/github.com/, '')
        end
        
        unless param.blank?
          param.sub!(/^\//, '')
          param.sub!(/.git/, '')
        
          res = JSON.parse(Net::HTTP.get(URI("https://api.github.com/repos/#{param}")))
          
          stars = res["watchers_count"]
          
          puts res
        
          [package[1]['name'], package[1]['description'], package[1]['maintainers'][0]['name'], stars, time_ago_in_words(Time.parse(package[1]['time']['modified'])), 'npm']
        end
      end
    end
  end
end