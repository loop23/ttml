# Ttml

Very simple Timed Text Markup Language parsing - I needed to parse a ttml file
and couldn't find a ruby implementation (probably because you don't really
need one!), so I wrote one.

## Installation

Add this line to your application's Gemfile:

    gem 'ttml'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install ttml

## Usage

tt = Ttml.parse({path_to_file}}
tt.subtitle_stream(:from => 0.0, :to => 100.0) do |event|
  puts event.inspect
end


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
