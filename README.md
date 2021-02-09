[![Gem Version](https://img.shields.io/gem/v/left_joins.svg?style=flat)](https://rubygems.org/gems/left_joins)
[![Build Status](https://github.com/khiav223577/left_joins/workflows/Ruby/badge.svg)](https://github.com/khiav223577/left_joins/actions)
[![RubyGems](http://img.shields.io/gem/dt/left_joins.svg?style=flat)](https://rubygems.org/gems/left_joins)
[![Code Climate](https://codeclimate.com/github/khiav223577/left_joins/badges/gpa.svg)](https://codeclimate.com/github/khiav223577/left_joins)
[![Test Coverage](https://codeclimate.com/github/khiav223577/left_joins/badges/coverage.svg)](https://codeclimate.com/github/khiav223577/left_joins/coverage)

# LeftJoins

Backport `left_joins` from Rails 5 for Rails 3 and 4.

## Supports
- Ruby 2.2 ~ 2.7
- Rails 3.2, 4.2, 5.0, 5.1, 5.2, 6.0

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'left_joins'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install left_joins

## Usage

Same as what you can do in Rails 5:
```rb
User.left_joins(:posts)
=> SELECT "users".* FROM "users" LEFT OUTER JOIN "posts" ON "posts"."user_id" = "users"."id"
```


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/khiav223577/left_joins. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

