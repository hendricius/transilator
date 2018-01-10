$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require 'minitest/autorun'


require 'rubygems'
require 'active_support'
require 'active_record'
require 'pry'
require 'transilator'

# Let's do our active record setup with the proper database
ActiveRecord::Base.logger = Logger.new(nil)
ActiveRecord::Base.establish_connection(adapter: "postgresql", host: '127.0.0.1')
ActiveRecord::Base.connection.execute('DROP DATABASE IF EXISTS transilator_test_database')
ActiveRecord::Base.connection.execute('CREATE DATABASE transilator_test_database')
ActiveRecord::Base.establish_connection(adapter: "postgresql", database: "translation_test_database", host: '127.0.0.1')
ActiveRecord::Base.connection.execute('CREATE EXTENSION IF NOT EXISTS hstore')

# i18n setup
I18n.enforce_available_locales = false
I18n.available_locales = [:en, :de]
I18n.locale = I18n.default_locale = :de

def setup_db
  ActiveRecord::Migration.verbose = false
  load "schema.rb"
end

def teardown_db
  ActiveRecord::Base.connection.tables.each do |table|
    ActiveRecord::Base.connection.drop_table(table)
  end
end

# create sample testable modle
class AbstractPost < ActiveRecord::Base
end

class TestPost < ActiveRecord::Base
  self.table_name = 'abstract_posts'
  transilator :title, :summary
end
