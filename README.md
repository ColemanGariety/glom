# Glom

#### Problem:

_To find a package for templating my new js project, I must open github.com and sift through people's crappy repos._

#### Solution:

    $ glom 'javascript templating'
    
    Searching `https://bower-component-list.herokuapp.com` for `templating`...
    Searching `http://jiyinyiyong.github.io/nipster/packages.json` for `templating`...
    
    +-----------------+-------------------------+---------------+-------+----------------+----------+
    | Name            | Description             | Author        | Stars | Last Updated   | Registry |
    +-----------------+-------------------------+---------------+-------+----------------+----------+
    | mustache        | Minimal templating      | janl          | 5457  | 3 months       | bower    |
    |                 | with {{mustaches}}      |               |       |                |          |
    |                 | in JavaScript           |               |       |                |          |
    | hogan           | A compiler for the      | twitter       | 2912  | 25 days        | bower    |
    |                 | Mustache templating     |               |       |                |          |
    |                 | language                |               |       |                |          |
    +-----------------+-------------------------+---------------+-------+----------------+----------+
    
## Installation

    $ gem install glom

## Contributing

Support for APIs can be added easily by adding `[Registry].rb` to the `lib/glom/registries` directory.

`[Registry].rb` should be a module with:

- a `KEYWORDS` array
- a `NAME` string
- a `URL` string
- a `standardize()` method that returns an array of packages

Example:

    # npm.rb
    
    module Bower
      KEYWORDS = ['bower', 'font-end', 'frontend', 'js', 'javascript']
      
      def get
        return [
          ['mustache', 'Minimal templating with {{mustaches}}', 'janl', 5457, '3 months', 'bower'],
          ['hogan', 'A compiler for the mustache templating language', 'twitter', 2912, '25 days', 'bower']
        ]
      end
    end

##### Glom helpers

The `Glom` module comes with two built-in helper methods that make standardizing APIs easier:

- Glom.get() - Gets a JSON file from the web and caches it, or pulls it from the cache if it exists
- Glom.match() - Breaks the package description and user's query into array of words and returns a boolean

##### Git for ~~losers~~ dummies

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request