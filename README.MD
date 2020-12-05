# Snap

The application will let you look up an author from goodreads and see their works. You can also look up the title itself and see all kinds of useful information about it. All in a snap!

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'snap'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install snap

## Usage

As a CLI, there are 4 options you will be presented with. 
1. Search for an author by name. Their top works will be presented to you. You then have the option to look at a work in further detail as well as save it or the author to your favorites for future reference.
2. You may look up a book by title. This will automatically show you all the relevant information about that book and you will again have the choice to save it or the author to your favorites.
3. You can look up your saved(favorite) authors, as well as be presented with some of their work.
4. You will see all your saved(favorite) books.

With options 1 and 2, you will be prompted to add them to your favorites with the keys 'y' and 'n'.

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/snap.


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
