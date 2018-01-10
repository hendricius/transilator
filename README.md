# Transilator

[![Build Status](https://travis-ci.org/hendricius/transilator.svg?branch=master)](https://travis-ci.org/hendricius/transilator)

Transilator makes storing translations for database records painless.

Instead of storing translations in different database tables, translations for your attributes are stored in a JSON or Hstore column directly in your table. Internally everything is stored as a hash with keys being locales and values the translations. Based on the locale whenever calling the attribute the translated value is retrieved internally.

Everything has been developed with performance in mind, especially when dealing with millions of records.
## Performance ##

**1,000,000 translation read operations**

transilator:
```
  1.310000   0.020000   1.330000 (  1.342136)
```

**Setting a new translation entry, 100,000 times**

transilator:
```
  6.650000   0.030000   6.680000 (  6.681483)
```

**Setting a completely new object with translations 100,000 times**

transilator:

```
  6.980000   0.020000   7.000000 (  7.000557)
```


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

This is a walkthrough with all steps you need to setup multilang translated attributes, including model and migration.

We're assuming here you want a Post model with some multilang attributes, as outlined below:

    class Post < ActiveRecord::Base
      transilator :title
    end

The multilang translations are stored in the same model attributes (eg. title):

You may need to create migration for Post as usual, but multilang attributes should be in hstore type:

    create_table(:posts) do |t|
      t.hstore :title
      t.timestamps
    end

Thats it!

Now you are able to translate values for the attributes :title and :description per locale:

    I18n.locale = :en
    post.title = 'Transilator rocks!'
    I18n.locale = :de
    post.title = 'Transilator pferdefleisch!'

    I18n.locale = :en
    post.title #=> Transilator rocks!
    I18n.locale = :de
    post.title #=> Transilator pferdefleisch!

If this is not enough, and sometimes you want to access one of the attributes directly you can also do:

    post.title_en = 'Hulk > Time punch'
    post.title_en #=> Hulk > Time punch


You may use initialization if needed:

    Post.new(title: {en: 'Cows rock', de: 'Kühe rocken'})

## Bugs and Feedback

Use [http://github.com/hendricius/transilator/issues](http://github.com/hendricius/transilator/issues)

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).


## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/hendricius/transilator.

## License(MIT)

* Copyright (c) 2015 Hendrik Kleinwaechter and Contributors
