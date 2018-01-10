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

  class Configuration
    attr_accessor :locale_fallbacks

    def initialize
      @locale_fallbacks = {}
    end
  end
end
