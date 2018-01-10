require "transilator/version"
require "transilator/active_record_extensions"

module Transilator
  class << self
    attr_accessor :configuration
  end

  def self.configure
    self.configuration ||= Configuration.new
    yield(configuration)
  end

  # returns the config object
  def self.config
    self.configuration = Configuration.new unless self.configuration
    self.configuration
  end

  class Configuration
    attr_accessor :locale_fallbacks

    def initialize
      @locale_fallbacks = {}
    end

    # returns an array with fallbacks for the given locale
    def get_fallbacks_for_locale(locale)
      locale_fallbacks[locale] || []
    end
  end
end
