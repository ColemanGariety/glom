# Glom

### Problem

    "To find a pakcage for templating my .js project, I must open github.com, sift through people's crappy projects, and locate the install command"

### Solution

    $ glom 'javascript templating'

## Installation

    $ gem install glom

## Usage

    $ glom 'javascript templating'
    
    Searching for 'templating' in bower.io and npmjs.org...
    
    +---------------+---------+
    |  Mustache.js  |  bower  |
    +---------------+---------+

## Contributing

Support for APIs can be added easily by adding `[ApiName].rb` to the `lib/glom/registries` directory.

`[ApiName].rb` should be a module with a `KEYWORDS` array and a `get()` method.

Example:

    # npm.rb
    
    module Npm
      KEYWORDS = ['npm', 'node', 'nodejs', 'js', 'javascript']
      
      def get
        # return [] of packages in here
      end
    end

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request