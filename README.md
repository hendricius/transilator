# Transilator

[![CircleCI](https://circleci.com/gh/hendricius/transilator.svg?style=svg)](https://circleci.com/gh/hendricius/transilator)

Transilator makes storing translations for database records painless.

Instead of storing translations in different database tables, translations for your attributes are stored in a JSON/JSONB or Hstore column directly in your table. Internally everything is stored as a hash with keys being locales and values the translations. Based on the locale whenever calling the attribute the translated value is retrieved internally.

Everything has been developed with performance in mind, especially when dealing with millions of records.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'transilator'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install transilator

## Usage

This is a walkthrough with all steps you need to get you up and running.

You may need to create migration for your model as usual. Assuming you have no
table yet, create the table:

```ruby
create_table :posts do |t|
  t.hstore :title  # note for this to work you need to enable the hstore extension in your database.
  t.jsonb :summary # this is the suggested way.
  t.timestamps
end
```

Then adjust your model and integrate transilator:

```ruby
class Post < ActiveRecord::Base
  transilator :title, :summary
end
```

Thats it!

**Basic usage**

Now you are able to translate values for the attributes :title and :description per locale:

```ruby
I18n.locale = :en
post.title = 'Eel is a typical food in Hamburg'
I18n.locale = :de
post.title = 'Aal ist typisch für Hamburg'

I18n.locale = :en
post.title #=> Eel is a typical food in Hamburg
I18n.locale = :de
post.title #=> Aal ist typisch für Hamburg
```

If this is not enough, and sometimes you want to access one of the attributes directly you can also do:


```ruby
post.title_en = 'I have no idea what I am doing'
post.title_en #=> I have no idea what I am doing
```

You can pass the values directly during initialisation of an object:
```ruby
Post.new(title: {en: 'The German', de: 'Serr German'})
```

**Fallbacks**

You can setup fallbacks in case you are missing data from one language. Then
the next language is used based on the order in the fallbacks array.

Create an initializer `initializers/transilator.rb` in your rails app.

```ruby
Transilator.configure do |config|
  config.locale_fallbacks = { "de" => ["en", "at"] }
end
```

Now in case we wouldn't have a German translation we fallback to English. If
we have no English translation then we will proceed and try our Austrian
translation. If that doesn't work then empty string is returned.


## Performance ##

When developing I tested against against [bithavoc/multilang-hstore](https://github.com/bithavoc/multilang-hstore) as this has been my choice for years.

**1,000,000 translation read operations**

transilator:
```
  1.310000   0.020000   1.330000 (  1.342136)
```

multilang-hstore:
```
  3.350000   0.040000   3.390000 (  3.383317)
```


**Setting a new translation entry, 100,000 times**

transilator:
```
  6.650000   0.030000   6.680000 (  6.681483)
```

multilang-hstore:
```
  6.860000   0.030000   6.890000 (  6.892723)
```

**Setting a completely new object with translations 100,000 times**

transilator:

```
  6.980000   0.020000   7.000000 (  7.000557)
```

multilang-hstore:

```
  7.620000   0.040000   7.660000 (  7.669240)
```

## Bugs and Feedback

Use [http://github.com/hendricius/transilator/issues](http://github.com/hendricius/transilator/issues)

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).


## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/hendricius/transilator

## License(MIT)

* Copyright (c) 2017 Hendrik Kleinwaechter and contributors
